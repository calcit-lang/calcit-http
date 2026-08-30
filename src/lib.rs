mod ffi;

calcit_native_ffi::export_buffer_abi_v1!();
calcit_native_ffi::export_async_abi_v1!();

use cirru_edn::{Edn, EdnMapView};
use ffi::*;
use std::collections::HashMap;
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::slice;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, LazyLock, Mutex};
use std::thread::Builder;
use std::time::Duration;
use tiny_http::{Method, Response, Server};

struct HttpServerOptions {
  port: u16,
  host: Arc<str>,
  response_timeout_ms: u64,
}

struct ResponseSkeleton {
  code: u16,
  headers: HashMap<Arc<str>, Arc<str>>,
  body: Arc<str>,
}

struct ServerControl {
  cancelled: AtomicBool,
}

struct HttpResponseContext {
  request: tiny_http::Request,
}

static NEXT_SERVER_CONTEXT: AtomicU64 = AtomicU64::new(1);
static SERVER_CONTROLS: LazyLock<Mutex<HashMap<u64, Arc<ServerControl>>>> = LazyLock::new(|| Mutex::new(HashMap::new()));

/// A side-effect-free ABI probe used by the Calcit integration test.
///
/// The probe deliberately shares the same dylib loading and EDN transport path
/// as the public server entrypoint, without binding a port or starting a
/// long-running server loop.
fn smoke_ping(args: Vec<Edn>) -> Result<Edn, String> {
  if !args.is_empty() {
    return Err(format!("smoke_ping expected no arguments, got {}", args.len()));
  }
  Ok(Edn::str("calcit-http-native-ok"))
}

calcit_native_ffi::export_edn_buffer_method_v1!(smoke_ping_calcit_ffi_v1, smoke_ping);

fn register_server_control() -> Result<(u64, Arc<ServerControl>), String> {
  let control = Arc::new(ServerControl {
    cancelled: AtomicBool::new(false),
  });
  let mut controls = SERVER_CONTROLS
    .lock()
    .map_err(|_| "HTTP server control registry is poisoned".to_owned())?;
  loop {
    let context = NEXT_SERVER_CONTEXT.fetch_add(1, Ordering::Relaxed);
    if context != 0 && !controls.contains_key(&context) {
      controls.insert(context, Arc::clone(&control));
      return Ok((context, control));
    }
  }
}

fn remove_server_control(context: u64) {
  if let Ok(mut controls) = SERVER_CONTROLS.lock() {
    controls.remove(&context);
  }
}

unsafe extern "C" fn cancel_http_server(task_context: u64, _task_handle: u64, reason_ptr: *const u8, reason_len: usize) -> i32 {
  catch_unwind(AssertUnwindSafe(|| {
    if reason_ptr.is_null() && reason_len != 0 {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let control = match SERVER_CONTROLS.lock() {
      Ok(controls) => controls.get(&task_context).cloned(),
      Err(_) => return ASYNC_STATUS_INTERNAL_ERROR,
    };
    let Some(control) = control else {
      return ASYNC_STATUS_HANDLE_FINISHED;
    };
    control.cancelled.store(true, Ordering::Release);
    ASYNC_STATUS_OK
  }))
  .unwrap_or(ASYNC_STATUS_INTERNAL_ERROR)
}

unsafe fn decode_response_value(payload_ptr: *const u8, payload_len: usize) -> Result<Edn, String> {
  if payload_ptr.is_null() && payload_len != 0 {
    return Err("HTTP response payload pointer is null".to_owned());
  }
  let payload = if payload_len == 0 {
    &[]
  } else {
    // SAFETY: the Calcit host keeps response bytes readable for this callback.
    unsafe { slice::from_raw_parts(payload_ptr, payload_len) }
  };
  let source = std::str::from_utf8(payload).map_err(|error| format!("HTTP response is not UTF-8: {error}"))?;
  cirru_edn::parse(source).map_err(|error| format!("HTTP response is not valid Cirru EDN: {error}"))
}

fn respond_to_request(request: tiny_http::Request, response: Result<ResponseSkeleton, String>) -> Result<(), String> {
  let response = match response {
    Ok(response) => response,
    Err(error) => ResponseSkeleton {
      code: 500,
      headers: HashMap::new(),
      body: Arc::from(error),
    },
  };
  let mut output = Response::from_string(response.body.to_string()).with_status_code(response.code);
  for (field, value) in response.headers {
    let header = format!("{field}: {value}")
      .parse::<tiny_http::Header>()
      .map_err(|_| format!("invalid HTTP response header: {field:?}"))?;
    output.add_header(header);
  }
  request
    .respond(output)
    .map_err(|error| format!("failed to send HTTP response: {error}"))
}

unsafe extern "C" fn resolve_http_response(
  response_context: u64,
  _response_handle: u64,
  outcome: u32,
  payload_ptr: *const u8,
  payload_len: usize,
) -> i32 {
  catch_unwind(AssertUnwindSafe(|| {
    if response_context == 0 {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    // SAFETY: one successful `open_response` transfers exactly one Box to the
    // host, which invokes this resolver at most once for resolve/reject/timeout.
    let context = unsafe { Box::from_raw(response_context as *mut HttpResponseContext) };
    let value = unsafe { decode_response_value(payload_ptr, payload_len) };
    let response = if outcome == ASYNC_RESPONSE_RESOLVE {
      value.and_then(|value| parse_response(&value))
    } else {
      Err(match value {
        Ok(reason) => format!("HTTP request rejected by Calcit: {reason}"),
        Err(error) => format!("HTTP request rejected by Calcit ({error})"),
      })
    };
    match respond_to_request(context.request, response) {
      Ok(()) => ASYNC_STATUS_OK,
      Err(error) => {
        eprintln!("{error}");
        ASYNC_STATUS_INTERNAL_ERROR
      }
    }
  }))
  .unwrap_or(ASYNC_STATUS_INTERNAL_ERROR)
}

fn publish_http_request(
  host: CalcitFfiAsyncHostV1,
  task: CalcitFfiAsyncTaskV1,
  control: &ServerControl,
  timeout_ms: u64,
  mut request: tiny_http::Request,
) -> Result<(), String> {
  let request_value = request_to_edn(&mut request)?;
  let payload = encode_callback_args(vec![request_value])?;
  let Some(open_response) = host.open_response else {
    return Err("Calcit async host does not provide open_response".to_owned());
  };
  let context = Box::new(HttpResponseContext { request });
  let response_context = Box::into_raw(context) as u64;
  let mut response_handle = 0;
  let status = unsafe {
    open_response(
      host.context,
      task.handle,
      response_context,
      timeout_ms,
      Some(resolve_http_response),
      &mut response_handle,
    )
  };
  if status != ASYNC_STATUS_OK {
    // SAFETY: ownership did not transfer when open_response failed.
    drop(unsafe { Box::from_raw(response_context as *mut HttpResponseContext) });
    return Err(format!(
      "Calcit host failed to open an HTTP response capability with status {status}"
    ));
  }
  let status = enqueue_with_backpressure_until(host, task, ASYNC_EVENT_EMIT, response_handle, &payload, || {
    !control.cancelled.load(Ordering::Acquire)
  });
  if status != ASYNC_STATUS_OK {
    // The host owns the response context after open_response succeeds. Failing
    // the server task makes the host reject and release that capability.
    if control.cancelled.load(Ordering::Acquire) && matches!(status, ASYNC_STATUS_HANDLE_CLOSING | ASYNC_STATUS_HANDLE_FINISHED) {
      return Ok(());
    }
    return Err(format!("Calcit host failed to enqueue an HTTP request with status {status}"));
  }
  Ok(())
}

fn run_http_server(
  options: HttpServerOptions,
  host: CalcitFfiAsyncHostV1,
  task: CalcitFfiAsyncTaskV1,
  control: Arc<ServerControl>,
) -> Result<(), String> {
  let address = format!("{}:{}", options.host, options.port);
  let server = Server::http(&address).map_err(|error| format!("failed to start HTTP server at {address}: {error}"))?;
  println!("Server started at {address}");
  while !control.cancelled.load(Ordering::Acquire) {
    match server.recv_timeout(Duration::from_millis(50)) {
      Ok(Some(request)) => publish_http_request(host, task, control.as_ref(), options.response_timeout_ms, request)?,
      Ok(None) => {}
      Err(error) => return Err(format!("HTTP server receive failed: {error}")),
    }
  }
  Ok(())
}

unsafe fn start_http_server_async_v1(
  request_ptr: *const u8,
  request_len: usize,
  task: *const CalcitFfiAsyncTaskV1,
  host: *const CalcitFfiAsyncHostV1,
) -> i32 {
  let task = match unsafe { copy_task_descriptor(task) } {
    Ok(task) => task,
    Err(status) => return status,
  };
  let host = match unsafe { copy_host_descriptor(host) } {
    Ok(host) => host,
    Err(status) => return status,
  };
  let args = match unsafe { decode_request(request_ptr, request_len) } {
    Ok(args) => args,
    Err(_) => return ASYNC_STATUS_INVALID_PAYLOAD,
  };
  let [options] = args.as_slice() else {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  };
  let options = match parse_options(options) {
    Ok(options) => options,
    Err(_) => return ASYNC_STATUS_INVALID_PAYLOAD,
  };
  let Some(configure) = host.configure_task else {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  };
  if host.enqueue.is_none() || host.open_response.is_none() {
    return ASYNC_STATUS_INVALID_PAYLOAD;
  }
  let (task_context, control) = match register_server_control() {
    Ok(value) => value,
    Err(_) => return ASYNC_STATUS_INTERNAL_ERROR,
  };
  let status = unsafe {
    configure(
      host.context,
      task.handle,
      ASYNC_TASK_SERVER,
      ASYNC_TASK_SERIAL_EVENTS | ASYNC_TASK_REQUIRES_RESPONSE,
      task_context,
      Some(cancel_http_server),
    )
  };
  if status != ASYNC_STATUS_OK {
    remove_server_control(task_context);
    return status;
  }
  let spawn_result = Builder::new().name("calcit-http-server".to_owned()).spawn(move || {
    let outcome = catch_unwind(AssertUnwindSafe(|| run_http_server(options, host, task, control)));
    let (kind, payload) = match outcome {
      Ok(Ok(())) => (ASYNC_EVENT_COMPLETE, b"&unit".to_vec()),
      Ok(Err(error)) => (ASYNC_EVENT_FAIL, encode_failure(error)),
      Err(_) => (ASYNC_EVENT_FAIL, encode_failure("HTTP server worker panicked")),
    };
    let status = enqueue_with_backpressure(host, task, kind, 0, &payload);
    if status != ASYNC_STATUS_OK {
      eprintln!("HTTP server task {} failed to terminate with status {status}", task.handle);
    }
    remove_server_control(task_context);
  });
  if spawn_result.is_err() {
    remove_server_control(task_context);
    return ASYNC_STATUS_INTERNAL_ERROR;
  }
  ASYNC_STATUS_OK
}

/// Start a cancellable HTTP server through Calcit's C-safe async protocol v1.
///
/// # Safety
///
/// Request bytes and descriptors must remain readable for this call. The
/// implementation copies all data retained by the server thread.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn serve_http_calcit_ffi_async_v1(
  request_ptr: *const u8,
  request_len: usize,
  task: *const CalcitFfiAsyncTaskV1,
  host: *const CalcitFfiAsyncHostV1,
) -> i32 {
  catch_unwind(AssertUnwindSafe(|| {
    // SAFETY: forwarded from the exported C contract above.
    unsafe { start_http_server_async_v1(request_ptr, request_len, task, host) }
  }))
  .unwrap_or(ASYNC_STATUS_INTERNAL_ERROR)
}

#[allow(clippy::mutable_key_type)]
fn request_to_edn(request: &mut tiny_http::Request) -> Result<Edn, String> {
  let mut fields: HashMap<Edn, Edn> = HashMap::new();
  fields.insert(Edn::tag("method"), Edn::tag(request.method().to_string()));
  let url = request.url().to_string();
  fields.insert(Edn::tag("url"), Edn::str(url.to_owned()));
  fields.insert(Edn::tag("secure"), Edn::Bool(request.secure()));
  fields.insert(
    Edn::tag("body-length"),
    match request.body_length() {
      Some(value) => Edn::Number(value as f64),
      None => Edn::Nil,
    },
  );
  fields.insert(
    Edn::tag("remote-addr"),
    match request.remote_addr() {
      Some(address) => Edn::str(address.to_string()),
      None => Edn::Nil,
    },
  );

  match url.split_once('?') {
    Some((path, querystring)) => {
      fields.insert(Edn::tag("path"), path.into());
      fields.insert(Edn::tag("querystring"), querystring.into());
      let mut query = HashMap::new();
      for (key, value) in querystring::querify(querystring) {
        query.insert(Edn::tag(key), value.into());
      }
      fields.insert(Edn::tag("query"), Edn::Map(EdnMapView(query)));
    }
    None => {
      fields.insert(Edn::tag("path"), url.into());
      fields.insert(Edn::tag("querystring"), "".into());
      fields.insert(Edn::tag("query"), Edn::Map(EdnMapView::default()));
    }
  }

  let mut headers = HashMap::new();
  for pair in request.headers() {
    headers.insert(Edn::tag(pair.field.to_string()), Edn::str(pair.value.to_string()));
  }
  fields.insert(Edn::tag("headers"), Edn::Map(EdnMapView(headers)));

  if request.method() != &Method::Get {
    let mut content = String::new();
    request
      .as_reader()
      .read_to_string(&mut content)
      .map_err(|error| format!("failed to read HTTP request body: {error}"))?;
    fields.insert(Edn::tag("body"), Edn::str(content));
  }

  Ok(Edn::Map(EdnMapView(fields)))
}

fn parse_options(d: &Edn) -> Result<HttpServerOptions, String> {
  match d {
    Edn::Nil => Ok(HttpServerOptions {
      port: 4000,
      host: Arc::from("0.0.0.0"),
      response_timeout_ms: 30_000,
    }),
    Edn::Map(m) => {
      let mut options = HttpServerOptions {
        port: 4000,
        host: Arc::from("0.0.0.0"),
        response_timeout_ms: 30_000,
      };
      options.port = match m.get(&Edn::tag("port")) {
        Some(Edn::Number(port)) if port.is_finite() && port.fract() == 0.0 && (1.0..=u16::MAX as f64).contains(port) => *port as u16,
        None => 4000,
        a => return Err(format!("invalid config for port: {:?}", a)),
      };
      options.host = match m.get(&Edn::tag("host")) {
        Some(Edn::Str(host)) => host.to_owned(),
        None => Arc::from("0.0.0.0"),
        a => return Err(format!("invalid config for host: {:?}", a)),
      };
      options.response_timeout_ms = match m.get(&Edn::tag("response-timeout-ms")) {
        Some(Edn::Number(timeout)) if timeout.is_finite() && timeout.fract() == 0.0 && (1.0..=86_400_000.0).contains(timeout) => {
          *timeout as u64
        }
        None => 30_000,
        value => return Err(format!("invalid response timeout: {value:?}")),
      };
      Ok(options)
    }
    _ => Err(format!("invalid data for options: {}", d)),
  }
}

/// from user response
#[allow(clippy::mutable_key_type)]
fn parse_response(info: &Edn) -> Result<ResponseSkeleton, String> {
  if let Edn::Map(m) = info {
    let mut res = ResponseSkeleton {
      code: 200,
      headers: HashMap::new(),
      body: String::from("").into(),
    };
    res.code = match m.get(&Edn::tag("code")) {
      Some(Edn::Number(code)) if code.is_finite() && code.fract() == 0.0 && (100.0..=599.0).contains(code) => *code as u16,
      None => 200,
      a => return Err(format!("invalid code: {:?}", a)),
    };
    res.body = match m.get(&Edn::tag("body")) {
      Some(Edn::Str(s)) => s.to_owned(),
      Some(a) => a.to_string().into(),
      None => String::from("").into(),
    };
    res.headers = match m.get(&Edn::tag("headers")) {
      Some(Edn::Map(m)) => {
        let mut hs: HashMap<Arc<str>, Arc<str>> = HashMap::new();
        for (k, v) in &m.0 {
          let k: Arc<str> = if let Edn::Tag(s) = k {
            Arc::from(s.ref_str())
          } else if let Edn::Str(s) = k {
            Arc::from(&**s)
          } else {
            return Err(format!("invalid header entry: {}", k));
          };
          let value = if let Edn::Str(s2) = v {
            s2.to_owned()
          } else {
            v.to_string().into()
          };
          format!("{k}: {value}")
            .parse::<tiny_http::Header>()
            .map_err(|_| format!("invalid HTTP response header: {k:?}"))?;
          hs.insert(k, Arc::from(&*value));
        }
        hs
      }
      Some(a) => return Err(format!("invalid data for headers: {}", a)),
      None => HashMap::new(),
    };
    Ok(res)
  } else {
    Err(format!("invalid response shape: {}", info))
  }
}

#[cfg(test)]
mod tests {
  use super::*;
  use calcit_native_ffi::{AsyncResponseResolve, AsyncTaskCancel, CalcitFfiBuffer};
  use std::io::{Read, Write};
  use std::net::{Shutdown, TcpListener, TcpStream};
  use std::ptr;
  use std::sync::Condvar;
  use std::sync::atomic::AtomicUsize;
  use std::thread;
  use std::time::{Duration, Instant};

  struct QueueFullHost {
    configured: Mutex<Option<(u64, AsyncTaskCancel)>>,
    configured_ready: Condvar,
    response: Mutex<Option<(u64, u64, AsyncResponseResolve)>>,
    response_opens: AtomicUsize,
    response_resolutions: AtomicUsize,
    response_status: AtomicU64,
    emit_attempts: AtomicUsize,
    emit_seen: Mutex<bool>,
    emit_ready: Condvar,
    terminal_kinds: Mutex<Vec<u32>>,
    finished: Mutex<bool>,
    finished_ready: Condvar,
  }

  impl QueueFullHost {
    fn new() -> Self {
      Self {
        configured: Mutex::new(None),
        configured_ready: Condvar::new(),
        response: Mutex::new(None),
        response_opens: AtomicUsize::new(0),
        response_resolutions: AtomicUsize::new(0),
        response_status: AtomicU64::new(u64::MAX),
        emit_attempts: AtomicUsize::new(0),
        emit_seen: Mutex::new(false),
        emit_ready: Condvar::new(),
        terminal_kinds: Mutex::new(Vec::new()),
        finished: Mutex::new(false),
        finished_ready: Condvar::new(),
      }
    }

    fn wait_for_configuration(&self) -> (u64, AsyncTaskCancel) {
      let configured = self.configured.lock().expect("configuration lock");
      let (configured, timeout) = self
        .configured_ready
        .wait_timeout_while(configured, Duration::from_secs(2), |value| value.is_none())
        .expect("wait for configuration");
      assert!(!timeout.timed_out(), "server task was not configured");
      configured.expect("configured callback")
    }

    fn wait_for_queue_full(&self) {
      let emit_seen = self.emit_seen.lock().expect("emit lock");
      let (emit_seen, timeout) = self
        .emit_ready
        .wait_timeout_while(emit_seen, Duration::from_secs(2), |value| !*value)
        .expect("wait for queue-full emit");
      assert!(!timeout.timed_out(), "HTTP request never reached the saturated host queue");
      assert!(*emit_seen);
    }

    fn wait_for_terminal(&self) {
      let finished = self.finished.lock().expect("finished lock");
      let (finished, timeout) = self
        .finished_ready
        .wait_timeout_while(finished, Duration::from_secs(2), |value| !*value)
        .expect("wait for terminal event");
      assert!(!timeout.timed_out(), "cancelled HTTP server did not publish a terminal event");
      assert!(*finished);
    }
  }

  unsafe fn queue_full_host(context: u64) -> &'static QueueFullHost {
    // SAFETY: each test keeps the boxed host state alive until the detached
    // server worker publishes its terminal event and removes its registry ID.
    unsafe { &*(context as *const QueueFullHost) }
  }

  unsafe extern "C" fn queue_full_enqueue(
    context: u64,
    _task_handle: u64,
    kind: u32,
    _response_handle: u64,
    _payload_ptr: *const u8,
    _payload_len: usize,
  ) -> i32 {
    let host = unsafe { queue_full_host(context) };
    if kind == ASYNC_EVENT_EMIT {
      host.emit_attempts.fetch_add(1, Ordering::AcqRel);
      if let Ok(mut emit_seen) = host.emit_seen.lock() {
        *emit_seen = true;
        host.emit_ready.notify_all();
      }
      return calcit_native_ffi::status::QUEUE_FULL;
    }
    if kind != ASYNC_EVENT_COMPLETE && kind != ASYNC_EVENT_FAIL {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let response = match host.response.lock() {
      Ok(mut response) => response.take(),
      Err(_) => return ASYNC_STATUS_INTERNAL_ERROR,
    };
    if let Some((response_context, response_handle, resolve)) = response {
      let reason = b"|server-cancelled";
      let status = unsafe {
        resolve(
          response_context,
          response_handle,
          calcit_native_ffi::response_outcome::REJECT,
          reason.as_ptr(),
          reason.len(),
        )
      };
      host.response_resolutions.fetch_add(1, Ordering::AcqRel);
      host.response_status.store(status as u64, Ordering::Release);
    }
    if let Ok(mut terminal_kinds) = host.terminal_kinds.lock() {
      terminal_kinds.push(kind);
    }
    if let Ok(mut finished) = host.finished.lock() {
      *finished = true;
      host.finished_ready.notify_all();
    }
    ASYNC_STATUS_OK
  }

  unsafe extern "C" fn queue_full_configure(
    context: u64,
    _task_handle: u64,
    kind: u32,
    flags: u32,
    task_context: u64,
    cancel: Option<AsyncTaskCancel>,
  ) -> i32 {
    if kind != ASYNC_TASK_SERVER || flags != ASYNC_TASK_SERIAL_EVENTS | ASYNC_TASK_REQUIRES_RESPONSE {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let Some(cancel) = cancel else {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    };
    let host = unsafe { queue_full_host(context) };
    match host.configured.lock() {
      Ok(mut configured) => {
        *configured = Some((task_context, cancel));
        host.configured_ready.notify_all();
        ASYNC_STATUS_OK
      }
      Err(_) => ASYNC_STATUS_INTERNAL_ERROR,
    }
  }

  unsafe extern "C" fn queue_full_open_response(
    context: u64,
    _task_handle: u64,
    response_context: u64,
    _timeout_ms: u64,
    resolve: Option<AsyncResponseResolve>,
    response_handle: *mut u64,
  ) -> i32 {
    if response_handle.is_null() {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    }
    let Some(resolve) = resolve else {
      return ASYNC_STATUS_INVALID_PAYLOAD;
    };
    let host = unsafe { queue_full_host(context) };
    let handle = 9001;
    match host.response.lock() {
      Ok(mut response) => {
        if response.is_some() {
          return ASYNC_STATUS_INTERNAL_ERROR;
        }
        *response = Some((response_context, handle, resolve));
        host.response_opens.fetch_add(1, Ordering::AcqRel);
        unsafe { *response_handle = handle };
        ASYNC_STATUS_OK
      }
      Err(_) => ASYNC_STATUS_INTERNAL_ERROR,
    }
  }

  fn reserve_local_port() -> u16 {
    TcpListener::bind("127.0.0.1:0")
      .expect("reserve local port")
      .local_addr()
      .expect("reserved local address")
      .port()
  }

  fn request_until_server_ready(port: u16) -> String {
    let deadline = Instant::now() + Duration::from_secs(2);
    let mut stream = loop {
      match TcpStream::connect(("127.0.0.1", port)) {
        Ok(stream) => break stream,
        Err(error) if Instant::now() < deadline => {
          thread::sleep(Duration::from_millis(5));
          let _ = error;
        }
        Err(error) => panic!("failed to connect to test HTTP server: {error}"),
      }
    };
    stream
      .set_read_timeout(Some(Duration::from_secs(2)))
      .expect("set client read timeout");
    stream
      .write_all(b"GET /queue-full HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n")
      .expect("send HTTP request");
    stream.shutdown(Shutdown::Write).expect("finish HTTP request");
    let mut response = String::new();
    stream.read_to_string(&mut response).expect("read rejected HTTP response");
    response
  }

  fn request_bytes(args: Vec<Edn>) -> Vec<u8> {
    calcit_native_ffi::encode_edn(&Edn::List(cirru_edn::EdnListView(args))).expect("encode request")
  }

  #[test]
  fn ffi_layouts_and_versions_are_stable() {
    assert_eq!(calcit_ffi_async_version(), 1);
    assert_eq!(calcit_ffi_buffer_version(), 1);
    assert_eq!(std::mem::size_of::<CalcitFfiAsyncTaskV1>(), 24);
    assert_eq!(std::mem::size_of::<CalcitFfiAsyncHostV1>(), 40);
  }

  #[test]
  fn smoke_probe_round_trips_through_buffer_v1() {
    let request = request_bytes(vec![]);
    let mut output = CalcitFfiBuffer {
      ptr: ptr::null_mut(),
      len: 0,
      cap: 0,
    };
    assert_eq!(unsafe { smoke_ping_calcit_ffi_v1(request.as_ptr(), request.len(), &mut output) }, 0);
    let bytes = unsafe { slice::from_raw_parts(output.ptr, output.len) };
    assert_eq!(
      cirru_edn::parse(std::str::from_utf8(bytes).expect("UTF-8")).expect("EDN"),
      Edn::str("calcit-http-native-ok")
    );
    unsafe { calcit_ffi_buffer_free(output) };
  }

  #[test]
  fn server_options_reject_lossy_numbers() {
    for (key, value) in [
      ("port", -1.0),
      ("port", 80.5),
      ("response-timeout-ms", 0.0),
      ("response-timeout-ms", 86_400_001.0),
    ] {
      let options = Edn::map_from_iter([(Edn::tag(key), Edn::Number(value))]);
      assert!(parse_options(&options).is_err(), "{key}={value} must be rejected");
    }
  }

  #[test]
  fn response_parser_rejects_invalid_status_and_headers() {
    let status = Edn::map_from_iter([(Edn::tag("code"), Edn::Number(99.0))]);
    assert!(parse_response(&status).is_err());

    let headers = Edn::map_from_iter([(
      Edn::tag("headers"),
      Edn::map_from_iter([(Edn::str("bad header"), Edn::str("value\nwith-newline"))]),
    )]);
    assert!(parse_response(&headers).is_err());
  }

  #[test]
  fn cancellation_uses_registry_ids_without_raw_context_pointers() {
    let (context, control) = register_server_control().expect("register server control");
    assert_eq!(unsafe { cancel_http_server(context, 7, ptr::null(), 0) }, ASYNC_STATUS_OK);
    assert!(control.cancelled.load(Ordering::Acquire));
    remove_server_control(context);
    assert_eq!(
      unsafe { cancel_http_server(context, 7, ptr::null(), 0) },
      ASYNC_STATUS_HANDLE_FINISHED
    );
  }

  #[test]
  fn cancel_during_queue_full_rejects_one_response_and_completes_once() {
    let port = reserve_local_port();
    let options = Edn::map_from_iter([
      (Edn::tag("host"), Edn::str("127.0.0.1")),
      (Edn::tag("port"), Edn::Number(f64::from(port))),
      (Edn::tag("response-timeout-ms"), Edn::Number(5_000.0)),
    ]);
    let request = request_bytes(vec![options]);
    let task = CalcitFfiAsyncTaskV1::new(77, calcit_native_ffi::task_kind::ONE_SHOT, 0);
    let host_state = Box::new(QueueFullHost::new());
    let host = CalcitFfiAsyncHostV1::new(
      (&*host_state as *const QueueFullHost) as u64,
      queue_full_enqueue,
      queue_full_configure,
      queue_full_open_response,
    );

    assert_eq!(
      unsafe { start_http_server_async_v1(request.as_ptr(), request.len(), &task, &host) },
      ASYNC_STATUS_OK
    );
    let (task_context, cancel) = host_state.wait_for_configuration();
    let client = thread::spawn(move || request_until_server_ready(port));
    host_state.wait_for_queue_full();
    assert_eq!(unsafe { cancel(task_context, task.handle, ptr::null(), 0) }, ASYNC_STATUS_OK);
    host_state.wait_for_terminal();

    let response = client.join().expect("HTTP client thread");
    assert!(response.starts_with("HTTP/1.1 500"), "unexpected response: {response}");
    assert!(response.contains("HTTP request rejected by Calcit"));
    assert!(host_state.emit_attempts.load(Ordering::Acquire) >= 1);
    assert_eq!(host_state.response_opens.load(Ordering::Acquire), 1);
    assert_eq!(host_state.response_resolutions.load(Ordering::Acquire), 1);
    assert_eq!(host_state.response_status.load(Ordering::Acquire), ASYNC_STATUS_OK as u64);
    assert_eq!(
      host_state.terminal_kinds.lock().expect("terminal kinds").as_slice(),
      &[ASYNC_EVENT_COMPLETE]
    );
    assert!(host_state.response.lock().expect("response registry").is_none());

    let deadline = Instant::now() + Duration::from_secs(1);
    loop {
      let status = unsafe { cancel(task_context, task.handle, ptr::null(), 0) };
      if status == ASYNC_STATUS_HANDLE_FINISHED {
        break;
      }
      assert_eq!(status, ASYNC_STATUS_OK);
      assert!(Instant::now() < deadline, "server control registry was not removed");
      thread::sleep(Duration::from_millis(1));
    }
  }
}

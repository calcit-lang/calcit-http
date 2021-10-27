use cirru_edn::Edn;
use std::collections::HashMap;
use std::sync::Arc;
use tiny_http::{Method, Response, Server};

struct HttpServerOptions {
  port: u16,
  host: String,
}

struct ResponseSkeleton {
  code: u8,
  headers: HashMap<String, String>,
  body: String,
}

#[no_mangle]
pub fn abi_version() -> String {
  String::from("0.0.1")
}

#[no_mangle]
pub fn serve_http(
  args: Vec<Edn>,
  handler: Arc<dyn Fn(Vec<Edn>) -> Result<Edn, String>>,
  _finish: Box<dyn FnOnce()>,
) -> Result<Edn, String> {
  if args.is_empty() {
    return Err(format!("expected an option, got nothing: {:?}", args));
  }
  let options = parse_options(&args[0])?;
  let server = Server::http(&format!("{}:{}", options.host, options.port)).unwrap();
  println!("Server started at {}:{}", options.host, options.port);

  for mut request in server.incoming_requests() {
    // println!(
    //   "received request! method: {:?}, url: {:?}, headers: {:?}",
    //   request.method(),
    //   request.url(),
    //   request.headers()
    // );

    let mut m: HashMap<Edn, Edn> = HashMap::new();
    m.insert(
      Edn::Keyword(String::from("method")),
      Edn::Keyword(request.method().to_string()),
    );
    m.insert(
      Edn::Keyword(String::from("url")),
      Edn::Str(request.url().to_string()),
    );

    let mut headers: HashMap<Edn, Edn> = HashMap::new();

    for pair in request.headers() {
      headers.insert(
        Edn::Keyword(pair.field.to_string()),
        Edn::Str(pair.value.to_string()),
      );
    }
    m.insert(Edn::Keyword(String::from("headers")), Edn::Map(headers));

    if request.method() != &Method::Get {
      let mut content = String::new();
      request.as_reader().read_to_string(&mut content).unwrap();
      m.insert(
        Edn::Keyword(String::from("body")),
        Edn::Str(content.to_string()),
      );
    }

    let info = Edn::Map(m);
    let result = handler(vec![info])?;
    let res = parse_response(&result)?;

    let mut response = Response::from_string(res.body.to_string()).with_status_code(res.code);

    for (field, value) in res.headers {
      response.add_header(
        format!("{}: {}", field, value)
          .parse::<tiny_http::Header>()
          .unwrap(),
      );
    }
    request.respond(response).map_err(|x| x.to_string())?;
  }

  Ok(Edn::Nil)
}

fn parse_options(d: &Edn) -> Result<HttpServerOptions, String> {
  match d {
    Edn::Nil => Ok(HttpServerOptions {
      port: 4000,
      host: String::from("0.0.0.0"),
    }),
    Edn::Map(m) => {
      let mut options = HttpServerOptions {
        port: 4000,
        host: String::from("0.0.0.0"),
      };
      options.port = match m.get(&Edn::Keyword(String::from("port"))) {
        Some(Edn::Number(port)) => *port as u16,
        None => 4000,
        a => return Err(format!("invalid config for port: {:?}", a)),
      };
      options.host = match m.get(&Edn::Keyword(String::from("host"))) {
        Some(Edn::Str(host)) => host.to_owned(),
        None => String::from("0.0.0.0"),
        a => return Err(format!("invalid config for host: {:?}", a)),
      };
      Ok(options)
    }
    _ => Err(format!("invalid data for options: {}", d)),
  }
}

/// from user response
fn parse_response(info: &Edn) -> Result<ResponseSkeleton, String> {
  if let Edn::Map(m) = info {
    let mut res = ResponseSkeleton {
      code: 200,
      headers: HashMap::new(),
      body: String::from(""),
    };
    res.code = match m.get(&Edn::Keyword(String::from("code"))) {
      Some(Edn::Number(n)) => *n as u8,
      None => 200,
      a => return Err(format!("invalid code: {:?}", a)),
    };
    res.body = match m.get(&Edn::Keyword(String::from("body"))) {
      Some(Edn::Str(s)) => s.to_owned(),
      Some(a) => a.to_string(),
      None => String::from(""),
    };
    res.headers = match m.get(&Edn::Keyword(String::from("headers"))) {
      Some(Edn::Map(m)) => {
        let mut hs: HashMap<String, String> = HashMap::new();
        for (k, v) in m {
          if let Edn::Keyword(s) = k {
            if let Edn::Str(s2) = v {
              hs.insert(s.to_owned(), s2.to_owned());
            } else {
              hs.insert(s.to_owned(), v.to_string());
            }
          } else {
            return Err(format!("invalid head entry: {}", k));
          }
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

use cirru_edn::Edn;
use std::collections::HashMap;
use std::sync::Arc;
use tiny_http::{Method, Response, Server};

struct HttpServerOptions {
  port: u16,
  host: Box<str>,
}

struct ResponseSkeleton {
  code: u8,
  headers: HashMap<Box<str>, Box<str>>,
  body: Box<str>,
}

#[no_mangle]
pub fn abi_version() -> String {
  String::from("0.0.5")
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
    m.insert(Edn::kwd("method"), Edn::kwd(&request.method().to_string()));
    m.insert(Edn::kwd("url"), Edn::str(request.url().to_string()));

    let mut headers: HashMap<Edn, Edn> = HashMap::new();

    for pair in request.headers() {
      headers.insert(
        Edn::kwd(&pair.field.to_string()),
        Edn::str(pair.value.to_string()),
      );
    }
    m.insert(Edn::kwd("headers"), Edn::Map(headers));

    if request.method() != &Method::Get {
      let mut content = String::new();
      request.as_reader().read_to_string(&mut content).unwrap();
      m.insert(
        Edn::kwd("body"),
        Edn::Str(content.to_string().into_boxed_str()),
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
      host: String::from("0.0.0.0").into_boxed_str(),
    }),
    Edn::Map(m) => {
      let mut options = HttpServerOptions {
        port: 4000,
        host: String::from("0.0.0.0").into_boxed_str(),
      };
      options.port = match m.get(&Edn::kwd("port")) {
        Some(Edn::Number(port)) => *port as u16,
        None => 4000,
        a => return Err(format!("invalid config for port: {:?}", a)),
      };
      options.host = match m.get(&Edn::kwd("host")) {
        Some(Edn::Str(host)) => host.to_owned(),
        None => String::from("0.0.0.0").into_boxed_str(),
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
      body: String::from("").into_boxed_str(),
    };
    res.code = match m.get(&Edn::kwd("code")) {
      Some(Edn::Number(n)) => *n as u8,
      None => 200,
      a => return Err(format!("invalid code: {:?}", a)),
    };
    res.body = match m.get(&Edn::kwd("body")) {
      Some(Edn::Str(s)) => s.to_owned(),
      Some(a) => a.to_string().into_boxed_str(),
      None => String::from("").into_boxed_str(),
    };
    res.headers = match m.get(&Edn::kwd("headers")) {
      Some(Edn::Map(m)) => {
        let mut hs: HashMap<Box<str>, Box<str>> = HashMap::new();
        for (k, v) in m {
          if let Edn::Keyword(s) = k {
            if let Edn::Str(s2) = v {
              hs.insert(s.to_str(), s2.to_owned());
            } else {
              hs.insert(s.to_str(), v.to_string().into_boxed_str());
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

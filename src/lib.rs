use cirru_edn::Edn;
use std::collections::HashMap;
use std::sync::Arc;
use tiny_http::{Method, Response, Server};

struct HttpServerOptions {
  port: u16,
  host: Box<str>,
}

struct ResponseSkeleton {
  code: u16,
  headers: HashMap<Box<str>, Box<str>>,
  body: Box<str>,
}

#[no_mangle]
pub fn abi_version() -> String {
  String::from("0.0.6")
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
    m.insert(Edn::tag("method"), Edn::tag(&request.method().to_string()));
    let url = request.url().to_string();
    m.insert(Edn::tag("url"), Edn::str(url.to_owned()));

    match url.split_once('?') {
      Some((path_part, query_part)) => {
        m.insert(Edn::tag("path"), path_part.into());
        m.insert(Edn::tag("querystring"), query_part.into());
        let query = querystring::querify(query_part);
        let mut query_dict = HashMap::new();
        for (k, v) in query {
          query_dict.insert(Edn::tag(k), v.into());
        }
        m.insert(Edn::tag("query"), Edn::Map(query_dict));
      }
      None => {
        m.insert(Edn::tag("path"), url.into());
        m.insert(Edn::tag("querystring"), "".into());
        m.insert(Edn::tag("query"), Edn::Map(HashMap::new()));
      }
    }

    let mut headers: HashMap<Edn, Edn> = HashMap::new();

    for pair in request.headers() {
      headers.insert(Edn::tag(&pair.field.to_string()), Edn::str(pair.value.to_string()));
    }
    m.insert(Edn::tag("headers"), Edn::Map(headers));

    if request.method() != &Method::Get {
      let mut content = String::new();
      request.as_reader().read_to_string(&mut content).unwrap();
      m.insert(Edn::tag("body"), Edn::Str(content.to_string().into_boxed_str()));
    }

    let info = Edn::Map(m);
    let result = handler(vec![info])?;
    let res = parse_response(&result)?;

    let mut response = Response::from_string(res.body.to_string()).with_status_code(res.code);

    for (field, value) in res.headers {
      response.add_header(format!("{}: {}", field, value).parse::<tiny_http::Header>().unwrap());
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
      options.port = match m.get(&Edn::tag("port")) {
        Some(Edn::Number(port)) => *port as u16,
        None => 4000,
        a => return Err(format!("invalid config for port: {:?}", a)),
      };
      options.host = match m.get(&Edn::tag("host")) {
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
    res.code = match m.get(&Edn::tag("code")) {
      Some(Edn::Number(n)) => *n as u16,
      None => 200,
      a => return Err(format!("invalid code: {:?}", a)),
    };
    res.body = match m.get(&Edn::tag("body")) {
      Some(Edn::Str(s)) => s.to_owned(),
      Some(a) => a.to_string().into_boxed_str(),
      None => String::from("").into_boxed_str(),
    };
    res.headers = match m.get(&Edn::tag("headers")) {
      Some(Edn::Map(m)) => {
        let mut hs: HashMap<Box<str>, Box<str>> = HashMap::new();
        for (k, v) in m {
          let k: Box<str> = if let Edn::Tag(s) = k {
            s.to_str()
          } else if let Edn::Str(s) = k {
            s.to_owned()
          } else {
            return Err(format!("invalid head entry: {}", k));
          };
          let value = if let Edn::Str(s2) = v {
            s2.to_owned()
          } else {
            v.to_string().into_boxed_str()
          };
          hs.insert(k, value);
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

use cirru_edn::Edn;
use std::collections::HashMap;
use std::sync::Arc;
use tiny_http::{Response, Server};

#[no_mangle]
pub fn serve_http(
  args: Vec<Edn>,
  handler: Arc<dyn Fn(Edn) -> Result<Edn, String>>,
) -> Result<Edn, String> {
  println!("TODO args: {:?}", args);
  let server = Server::http("0.0.0.0:8000").unwrap();

  for request in server.incoming_requests() {
    // println!(
    //   "received request! method: {:?}, url: {:?}, headers: {:?}",
    //   request.method(),
    //   request.url(),
    //   request.headers()
    // );

    let mut m: HashMap<Edn, Edn> = HashMap::new();
    m.insert(
      Edn::Keyword(String::from("method")),
      Edn::Str(request.method().to_string()),
    );
    m.insert(
      Edn::Keyword(String::from("url")),
      Edn::Str(request.url().to_string()),
    );
    let info = Edn::Map(m);
    let result = handler(info)?;

    let response = Response::from_string(result.to_string());
    request.respond(response).map_err(|x| x.to_string())?;
  }

  Ok(Edn::Nil)
}

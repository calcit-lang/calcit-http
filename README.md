## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

The native server passes a request map into your callback and expects a response map back. Typical request keys include `:method`, `:url`, `:path`, `:querystring`, `:query`, `:headers`, and `:body` for non-GET requests.

### Usages

APIs:

```cirru
http.core/serve-http!
  {}
    :port 4000
    :host "|0.0.0.0"
  fn (req)
    on-request req

defn on-request (req)
  {}
    :code 200
    :headers $ {}
      :content-type |application/json
    :body "|some content"
```

The callback should return a response map with:

- `:code` - numeric HTTP status, default `200`
- `:headers` - map of header name to string value
- `:body` - response body string

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT

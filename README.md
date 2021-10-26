## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

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

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT

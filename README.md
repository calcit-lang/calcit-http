## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

The native server passes a request map into your callback and expects a response map back. Typical request keys include `:method`, `:url`, `:path`, `:querystring`, `:query`, `:headers`, and `:body` for non-GET requests.

### Usages

APIs:

```cirru
http.core/serve-http!
  {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
  fn (req) (on-request req)

defn on-request (req)
  {} (:code 200)
    :headers $ {} (:content-type |application/json)
    :body "|some content"
```

The callback should return a response map with:

- `:code` - numeric HTTP status, default `200`
- `:headers` - map of header name to string value
- `:body` - response body string

`serve-http!` returns an opaque native task capability. Stop the server with
`&ffi-task-cancel`; cancellation is acknowledged only after the native server
loop has stopped and emitted its terminal event. Each request owns an
exactly-once response capability internally. If the handler does not resolve it
within `:response-timeout-ms` (default 30 seconds), Calcit rejects it and the
native binding returns an HTTP 500 response.

Maintainers can run `bash scripts/check-server-ffi.sh` after copying the release
dylib into `dylibs/`. The smoke performs a real request, resolves it, cancels
the returned task capability, and requires the Calcit host to exit cleanly.

Install with `caps add calcit-lang/http@<tag>` and run `caps`. The project-local
`.calcit/modules/` view points at the versioned global module store. Compile and provide
the matching `*.{dylib,so,dll}` file with `./build.sh`.

### Quality and runtime contracts

This module uses the RFC Q1 ratchet: CI runs Calcit's native
`analyze quality --baseline config/calcit-quality.json` gate. The reviewed
baseline is intentionally limited to the native request/response callback ABI;
it must not grow without an explicit review. Calcit is installed from the
project's `deps.cirru` through
[`calcit-lang/setup-calcit@v1.3.0`](https://github.com/calcit-lang/setup-calcit/releases/tag/v1.3.0).

The same CI is also Q3 evidence: it builds the Rust dylib, copies the actual
artifact into `dylibs/`, and executes the Calcit entry that loads it. Static
quality constrains the Calcit boundary, but does not replace this ABI/runtime
test.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT

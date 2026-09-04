## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

The native server passes a request map into your callback and expects a response map back. Typical request keys include `:method`, `:url`, `:path`, `:querystring`, `:query`, `:headers`, and `:body` for non-GET requests.

### Usages

APIs:

```cirru.no-run
http.core/serve-http!
  {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
  fn (req)
    {} (:code 200)
      :headers $ {} (:content-type |application/json)
      :body "|some content"
```

The callback should return a response map with:

- `:code` - numeric HTTP status, default `200`
- `:headers` - map of header name to string value
- `:body` - response body string

`serve-http!` returns a typed `FfiTask`. Stop the server with `.cancel` or
`.cancel-with`; cancellation is acknowledged only after the native server
loop has stopped and emitted its terminal event. Each request owns an
exactly-once response capability internally. If the handler does not resolve it
within `:response-timeout-ms` (default 30 seconds), Calcit rejects it and the
native binding returns an HTTP 500 response.

Maintainers can run `bash scripts/check-server-ffi.sh` after copying the release
dylib into `dylibs/`. The smoke performs a real request, resolves it, cancels
the returned task capability, and requires the Calcit host to exit cleanly.

### 共享 FFI 基础层 / Shared FFI foundation

本模块使用 [`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi)
维护 C-safe buffer、async descriptors、Cirru EDN adapter 和 backpressure
transport。HTTP request/response capability、server registry 与取消顺序仍由本仓库维护。

This module uses
[`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi) for the
C-safe buffer, async descriptors, Cirru EDN adapters, and backpressure
transport. HTTP request/response capabilities, the server registry, and
cancellation ordering remain owned by this repository.

HTTP request `emit` 在等待 host queue 时会检查 server cancel，最长 10ms 响应；
持续 `QUEUE_FULL` 默认 5 秒后失败。取消或失败后的 terminal 事件仍独立发布，
由 host exactly-once reject/release 已打开的 response capabilities。

要求 Calcit `0.13.60` 或更高版本，以便取消时也会清理已经排队的 request
事件，同时不丢弃 server terminal 事件。

HTTP request `emit` observes server cancellation while waiting for host queue
capacity, with at most 10ms between checks; persistent `QUEUE_FULL` fails after
the default five-second deadline. Terminal publication remains independent so
the host can reject and release opened response capabilities exactly once.

Calcit `0.13.60` or newer is required so cancellation also purges already
queued request events without discarding the server's terminal event.

Install with `caps add calcit-lang/http@<tag>` and run `caps`. The project-local
`.calcit/modules/` view points at the versioned global module store. Compile and provide
the matching `*.{dylib,so,dll}` file with `./build.sh`.

### Quality and runtime contracts

This module uses the RFC Q1 ratchet: CI runs Calcit's native
`analyze quality --baseline config/calcit-quality.json` gate. The reviewed
baseline is intentionally limited to the native request/response callback ABI;
it must not grow without an explicit review. Calcit is installed from the
project's `deps.cirru` through
[`calcit-lang/setup-calcit@v1`](https://github.com/calcit-lang/setup-calcit).

The same CI is also Q3 evidence: it builds the Rust dylib, copies the actual
artifact into `dylibs/`, and executes the Calcit entry that loads it. Static
quality constrains the Calcit boundary, but does not replace this ABI/runtime
test.

### Workflow

https://github.com/calcit-lang/dylib-workflow

For request/response capability and cancellation guidance, use
`calcit docs read "HTTP server response capabilities" --module calcit-http`
after installation.

### License

MIT

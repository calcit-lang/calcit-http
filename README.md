## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

使用者注意：当前源码配对 Calcit **0.42.1**。需要具名请求和响应时可使用 `serve-http-typed!`。已有的 `serve-http!` Map 回调仍可直接使用，回调可以保留自己声明的响应值类型。两者都用 `Option :none` 选择默认配置，或用 `Option :some` 包装配置 Map。升级时须重新构建目标架构动态库并重启原生进程。使用 Calcit 0.37.0 的项目可继续锁定 **0.4.0**。

旧 CLI 消费者应保留原 tag。CLI 兼容性注意：0.32.0 的 native `identical?` 对容器改为身份比较，比较内容应使用 `=`；本模块没有该调用，不机械改写 HTTP 行为。

The native server passes a request map into your callback and expects a response map back. Typical request keys include `:method`, `:url`, `:path`, `:querystring`, `:query`, `:headers`, and `:body` for non-GET requests.

### Usages

APIs:

```cirru.no-run
http.core/serve-http!
  Option :some $ decode-map-as
    {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
    Map Tag http.core/ServerOptionValue
  fn (req)
    {} (:code 200)
      :headers $ {} $ :content-type |application/json
      :body "|some content"
```

The callback should return a response map with:

- `:code` - numeric HTTP status, default `200`
- `:headers` - map of header name to string value
- `:body` - response body string

具名接口的请求正文、长度和远端地址使用 `Option`。响应头值是 String，键可使用 Tag 或 String。
在服务运行期间保留 `typed-server-task`，并在应用的关闭回调中调用示例末尾的取消操作。

```cirru.no-run
let
    typed-server-task $ http.core/serve-http-typed! (Option :none)
      fn (request)
        hint-fn $ Fn http.core/Request $ -> http.core/Response
        http.core/Response :code 200 :headers ({}) :body $ :path request
  typed-server-task.cancel-with! :shutdown
```

`serve-http!` returns a typed `FfiTask`. Stop the server with `.cancel!` or
`.cancel-with!`; cancellation is acknowledged only after the native server
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

本模块要求 deps.cirru 声明的精确 Calcit `0.42.1`；取消时会清理已排队的 request
事件，同时保留 server terminal 事件。

HTTP request `emit` observes server cancellation while waiting for host queue
capacity, with at most 10ms between checks; persistent `QUEUE_FULL` fails after
the default five-second deadline. Terminal publication remains independent so
the host can reject and release opened response capabilities exactly once.

This module requires the exact Calcit `0.42.1` declared in deps.cirru.
Cancellation purges queued request events without discarding the server's
terminal event. The native ABI and request/response wire format remain unchanged.

`ServerOptionValue` 用 `Number | String` 描述配置项。原生层继续检查端口、超时范围及主机字段。具名响应适配器以 `ResponseWireValue` 描述发送到原生层的 Number、String 和响应头 Map。请求与响应仍以 Map 经过 C-safe buffer/async protocol v1。Cargo crate 保持 0.3.23。

Declare `calcit-lang/calcit-http` with a compatible published tag in your
project's `deps.cirru` dependencies, then run `caps --ci`. The project-local
`.calcit/modules/` view points at the versioned global module store. Compile and provide
the matching `*.{dylib,so,dll}` file with `./build.sh`.

### Quality and runtime contracts

CI runs default strict checks for both native entries and all public
namespaces. The typed callback receives `Request` and returns `Response`.
The existing Map callback continues to accept heterogeneous response fields.
Calcit is installed from the project's `deps.cirru` through
[`calcit-lang/setup-calcit@v1.5.0`](https://github.com/calcit-lang/setup-calcit).

原生请求在长度或远端地址不可用时携带 nil，具名接口将其解码为 `Option :none`。
原 Map 回调的响应 body 和 header 值继续使用 Rust 的文本转换。

CI also builds the Rust dylib, copies the actual artifact into `dylibs/`, and
executes the Calcit entry that loads it. Strict checks do not replace this
ABI/runtime test. The original Rust tests and real request/response/cancellation
smoke remain required. Run `sh build.sh` before local native acceptance.
The build entry is POSIX-compatible because Caps invokes it with `sh`;
0.3.22 fixes the Bash-only `pipefail` startup failure on Linux.
No frontend or COS deployment is involved.

Formal Action tags follow the maintainer policy, but can move;
read-only permissions do not make their code immutable.

### Workflow

https://github.com/calcit-lang/dylib-workflow

For request/response capability and cancellation guidance, use
`calcit docs read "HTTP server response capabilities" --module calcit-http`
after installation.

### License

MIT

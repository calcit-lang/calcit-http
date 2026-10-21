## HTTP server binding for Calcit

> Rust HTTP library for Calcit runtime.

使用者注意：候选模块 **0.3.24** 配对正式 Calcit **0.30.1**，仅运行 native，
没有 npm runtime 配对，也不承诺 JS/WASM 支持。请使用适合本机架构的动态库并
重启原生进程。本次 Snapshot、Rust、Cargo 依赖/lock、API、请求响应与取消合同不变。
版本号不表示已发布；完整验收和正式 tag 以 PR / Release 为准，不部署任何服务。

The native server passes a request map into your callback and expects a response map back. Typical request keys include `:method`, `:url`, `:path`, `:querystring`, `:query`, `:headers`, and `:body` for non-GET requests.

### Usages

APIs:

```cirru.no-run
http.core/serve-http!
  {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
  fn (req)
    {} (:code 200)
      :headers $ {} $ :content-type |application/json
      :body "|some content"
```

The callback should return a response map with:

- `:code` - numeric HTTP status, default `200`
- `:headers` - map of header name to string value
- `:body` - response body string

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

要求 Calcit `0.13.60` 或更高版本，以便取消时也会清理已经排队的 request
事件，同时不丢弃 server terminal 事件。

HTTP request `emit` observes server cancellation while waiting for host queue
capacity, with at most 10ms between checks; persistent `QUEUE_FULL` fails after
the default five-second deadline. Terminal publication remains independent so
the host can reject and release opened response capabilities exactly once.

Calcit `0.13.60` or newer is required so cancellation also purges already
queued request events without discarding the server's terminal event. Release
`0.3.23` targets released Calcit `0.29.3` without changing the native ABI or
request/response wire format.

当前源码候选从 alpha.5 对齐正式 Calcit 0.30.1，验收后发布模块 0.3.24；
不修改 Snapshot、Rust、Cargo 依赖/lock、请求/响应格式或 buffer/async protocol v1。
本库仅运行 native，没有 npm runtime 配对。本次结果需独立验证，不沿用旧 alpha
验收冒充正式支持。完整 `fix --workflow strict --verify` 在原 0.29.3 下会
复现 [calcit#2047](https://github.com/calcit-lang/calcit/issues/2047) 的 core
`ffi-response:resolve` Unit 返回证明问题；正式 0.30.0 对照已通过这项审计。
不以普通检查或运行 smoke 成功代替完整 strict，也不添加返回强转或兼容代码绕过。
本轮保留完整 strict、全部定义及 server 入口、公开命名空间门禁；全部定义检查
已覆盖 default，不再重复跑其普通检查。以下局部状态迁移是既有源码：原服务器
集成脚本的局部状态使用首选 `ref` 替代兼容旧名 `atom`，不改变 Option/FfiTask 合同，
不新增校验脚本、预算或编译器改写。

Declare `calcit-lang/calcit-http` with a compatible published tag in your
project's `deps.cirru` dependencies, then run `caps --ci`. The project-local
`.calcit/modules/` view points at the versioned global module store. Compile and provide
the matching `*.{dylib,so,dll}` file with `./build.sh`.

### Quality and runtime contracts

CI runs default strict checks for both native entries and all public
namespaces. The callback takes and returns `Map<Tag,Dynamic>`; raw native
requests are decoded before entering the handler. Heterogeneous HTTP fields
and the Rust-validated options remain explicit boundaries, not whole-Dynamic
callback contracts. Calcit is installed from the project's `deps.cirru` through
[`calcit-lang/setup-calcit@v1.5.0`](https://github.com/calcit-lang/setup-calcit).

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

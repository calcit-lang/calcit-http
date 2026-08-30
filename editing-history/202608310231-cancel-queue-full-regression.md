# 2026-08-31：取消 QUEUE_FULL 中的 HTTP 请求 / Cancel HTTP request during QUEUE_FULL

- Added a real localhost HTTP-server regression backed by a fake C-safe Calcit host whose request-event queue remains saturated.
- The test waits until request `emit` receives `QUEUE_FULL`, invokes the registered server cancellation callback, and verifies bounded worker completion.
- The fake host records one response capability, rejects/releases it exactly once when the server publishes its terminal event, and confirms exactly one `COMPLETE` event.
- The regression also verifies the client receives the deterministic 500 rejection response and the server-control registry is removed.
- Documented that cancellation interrupts queue-full delivery while terminal cleanup remains exactly once.
- Raised the verified Calcit toolchain declaration from `0.13.64` to `0.13.67` so local and CI validation use the current release.

## 中文摘要

- 增加真实 localhost HTTP server 与伪 C-safe host 回归，令 request `emit` 持续返回 `QUEUE_FULL`。
- 在队列饱和期间调用已注册的 cancel callback，验证 worker 有界退出。
- 验证 response capability 只创建一次、reject/release 一次，server terminal `COMPLETE` 只发布一次，并最终清理 control registry。
- 文档明确取消会中断 `QUEUE_FULL` 重试，但仍以单个 terminal event 驱动未决 response capability 的 exactly-once 清理。
- 将已验证的 Calcit 工具链声明从 `0.13.64` 同步到当前发布版 `0.13.67`，统一本地与 CI 基线。

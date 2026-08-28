# 使用共享 native FFI crate / Adopt the shared native FFI crate

## 中文

- 用 `calcit_native_ffi 0.1.0` 替换本地复制的 C ABI descriptors、buffer、EDN 与 transport 模板。
- 保留 HTTP response capability、server registry、cancel handler 和原有公开 symbols。
- 补充共享层职责与本仓库业务边界文档。

## English

- Replace local C ABI descriptor, buffer, EDN, and transport templates with `calcit_native_ffi 0.1.0`.
- Preserve HTTP response capabilities, the server registry, cancellation handlers, and public symbols.
- Document the shared-layer responsibilities and this repository's business boundary.

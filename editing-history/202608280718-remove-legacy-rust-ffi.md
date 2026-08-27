# Remove legacy Rust FFI exports / 删除遗留 Rust FFI 导出

## 中文

- 删除 version probes 和旧 Rust callback server entry point，`smoke_ping` 仅作为 C-safe buffer adapter 的内部 handler。
- 改用 `cdylib`，仅导出 buffer v1 与 async Server/Response v1 的固定 C ABI。
- 升级 Calcit 要求到 0.13.57。
- CI 增加 Rust tests、strict clippy 和 C-safe symbol audit。

## English

- Remove version probes and the old Rust callback server entry point; keep `smoke_ping` only as an internal C-safe buffer-adapter handler.
- Use `cdylib` so only the fixed buffer-v1 and async Server/Response-v1 C ABI is exported.
- Upgrade the Calcit requirement to 0.13.57.
- Add Rust tests, strict clippy, and a C-safe symbol audit to CI.

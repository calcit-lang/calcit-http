# C-safe HTTP Server/Response FFI v1

- Added buffer protocol v1 for the synchronous native smoke probe and async
  protocol v1 for `serve_http` while retaining both legacy Rust ABI symbols as
  per-method migration fallbacks.
- Configured the native HTTP listener as a cancellable, serialized Server task
  that requires one exactly-once response capability per request. The Calcit
  wrapper resolves the handler's response map internally and returns the
  opaque task capability for explicit cancellation.
- Added bounded response timeouts, host queue backpressure, panic containment,
  size-aware C descriptor copying, and an ID-based cancellation registry that
  never exposes Rust pointers as task contexts.
- Removed lossy numeric casts for ports, status codes, and timeouts; replaced
  request-body and response-header unwraps with descriptive errors.
- Migrated the platform macro to a strict `Macro` contract, corrected the test
  entry's `Unit` return, upgraded the project to Calcit 0.13.52, and pinned
  setup-calcit to release tag `v1.3.0`.
- Added five Rust regression tests and a real CI smoke that starts the release
  dylib, serves one localhost request, resolves its response, cancels the task,
  and requires the Calcit host to exit cleanly.

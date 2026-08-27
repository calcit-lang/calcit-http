## Calcit HTTP development guide

This repository provides the native HTTP binding used by Calcit projects. Keep the Rust ABI and the Calcit boundary in sync.

### Calcit workflow

- `calcit.cirru` is the only project Snapshot. Do not add or maintain a legacy Snapshot file.
- Before using any `calcit edit`, `calcit tree`, or cursor mutation, run:

  ```bash
  calcit docs agents --full
  calcit docs read upgrade
  ```

- The current CLI is `calcit`; normal execution is once by default:

  ```bash
  calcit calcit.cirru --check-only
  calcit calcit.cirru
  calcit calcit.cirru js
  calcit calcit.cirru --entry server
  ```

- Use `calcit edit`/`calcit tree` for Snapshot edits. Run `calcit.cirru edit format` and inspect the diff before committing.

### Rust and FFI contracts

- Keep `cirru_edn = "0.8.0"` and `cirru_parser = "0.2.8"` compatible with the current Calcit runtime.
- Prefer the versioned C-safe ABIs. Synchronous methods use buffer protocol v1;
  callback methods use async protocol v1. Keep legacy Rust symbols only as
  per-method migration fallbacks until Calcit removes fallback support.
- Export `abi_version() -> String` and `edn_version() -> String` while the
  legacy fallback remains; the latter returns `cirru_edn::version().to_string()`.
- Rust 2024 exports use `#[unsafe(no_mangle)]`.
- Preserve the request/response map keys documented in `README.md`.
- `serve_http_calcit_ffi_async_v1` is a cancellable Server task with serialized
  request events and exactly-once response capabilities. Every accepted cancel
  must enqueue one terminal event.

### Verification

Run the following after changing Rust or the Calcit boundary:

```bash
caps --ci
calcit calcit.cirru edit format
git diff --exit-code -- calcit.cirru
calcit calcit.cirru --check-only
calcit calcit.cirru analyze quality --baseline config/calcit-quality.json --format json
cargo build --release
rm -rf dylibs/*
mkdir -p dylibs
cp target/release/*.* dylibs/
calcit calcit.cirru
bash scripts/check-server-ffi.sh
```

For the `server` entry, verify a response with `curl http://127.0.0.1:4000/`,
then cancel the returned task capability with `&ffi-task-cancel`. Confirm that
the dylib copied into `dylibs/` is the artifact just built.

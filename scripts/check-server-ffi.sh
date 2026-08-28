#!/usr/bin/env bash

set -euo pipefail

smoke_dir="$(mktemp -d)"
smoke_log="$smoke_dir/calcit-http-server.log"
server_pid=""

cleanup() {
  if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$smoke_dir"
}
trap cleanup EXIT

calcit calcit.cirru eval --dep ./ -- 'ns app.main $ :require
  http.util :refer $ get-dylib-path

let
    task-ref $ atom &unit
    task $ ffi:task $ &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |serve_http
      {} (:host |127.0.0.1) (:port 18081) (:response-timeout-ms 5000)
      fn (request response!)
        let
            response $ ffi:response response!
          response.resolve $ {} (:code 200) (:body |ffi-ok)
        .cancel-with (deref task-ref) :smoke-complete
  reset! task-ref task
  , task' >"$smoke_log" 2>&1 &
server_pid="$!"

response=""
for _ in {1..50}; do
  if response="$(curl --fail --silent --max-time 1 'http://127.0.0.1:18081/ffi-smoke?x=1')"; then
    break
  fi
  sleep 0.1
done

if [[ "$response" != "ffi-ok" ]]; then
  cat "$smoke_log"
  echo "expected server smoke response 'ffi-ok', got '$response'" >&2
  exit 1
fi

for _ in {1..50}; do
  if ! kill -0 "$server_pid" 2>/dev/null; then
    break
  fi
  sleep 0.1
done

if kill -0 "$server_pid" 2>/dev/null; then
  cat "$smoke_log"
  echo "Calcit host did not exit after the server task acknowledged cancellation" >&2
  exit 1
fi

if ! wait "$server_pid"; then
  cat "$smoke_log"
  echo "Calcit server smoke exited unsuccessfully" >&2
  exit 1
fi
server_pid=""

cat "$smoke_log"

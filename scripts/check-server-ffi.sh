#!/usr/bin/env bash

set -euo pipefail

smoke_dir="$(mktemp -d)"
smoke_log="$smoke_dir/calcit-http-server.log"
server_pid=""
port=18081

cleanup() {
  if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$smoke_dir"
}
trap cleanup EXIT

if [[ "${1:-}" == default ]]; then
  port=4000
  program='ns app.main $ :require
  http.core :refer $ serve-http!

let
    task-ref $ ref $ assert-type (Option :none) $ Option FfiTask
    task $ serve-http! (Option :none) $ fn (request)
      when (= (get request :path) (Option :some |/ffi-stop))
        .map (deref task-ref) $ fn (server-task)
          hint-fn $ Fn FfiTask (-> Unit)
          .cancel-with! server-task :smoke-complete
      {} (:code 200) (:body |ffi-ok)
  reset! task-ref $ Option :some task
  , task'
else
  program='ns app.main $ :require
  http.util :refer $ get-dylib-path

let
    task-ref $ ref $ assert-type (Option :none) $ Option FfiTask
    task $ ffi:task $ &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |serve_http
      {} (:host |127.0.0.1) (:port 18081) (:response-timeout-ms 5000)
      fn (request response!)
        let
            response $ ffi:response response!
          response.resolve! $ {} (:code 200) (:body |ffi-ok)
        .map (deref task-ref) $ fn (server-task)
          hint-fn $ Fn FfiTask (-> Unit)
          .cancel-with! server-task :smoke-complete
  reset! task-ref $ Option :some task
  , task'
fi

calcit calcit.cirru eval --dep ./ -- "$program" >"$smoke_log" 2>&1 &
server_pid="$!"

response=""
for _ in {1..50}; do
  if response="$(curl --noproxy '*' --fail --silent --max-time 1 "http://127.0.0.1:$port/ffi-smoke?x=1")"; then
    break
  fi
  sleep 0.1
done

if [[ "$response" != "ffi-ok" ]]; then
  cat "$smoke_log"
  echo "expected server smoke response 'ffi-ok', got '$response'" >&2
  exit 1
fi

if [[ "${1:-}" == default ]]; then
  # Cancelling the task can close the connection before this second response.
  curl --noproxy '*' --silent --max-time 1 "http://127.0.0.1:$port/ffi-stop" >/dev/null || true
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

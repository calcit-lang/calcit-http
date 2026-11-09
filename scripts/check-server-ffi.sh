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

if [[ "${1:-}" == typed ]]; then
  port=18082
  program='ns app.main $ :require
  http.core :refer $ serve-http-typed! Request Response

let
    task-ref $ ref $ assert-type (Option :none) $ Option FfiTask
    task $ serve-http-typed!
      Option :some $ decode-map-as
        {} (:host |127.0.0.1) (:port 18082) (:response-timeout-ms 5000)
        Map Tag http.core/ServerOptionValue
      fn (request)
        hint-fn $ Fn Request (-> Response)
        match (:path request)
          |/ffi-stop
            .map (deref task-ref) $ fn (server-task)
              hint-fn $ Fn FfiTask (-> Unit)
              .cancel-with! server-task :smoke-complete
          |/ffi-post
            do
              assert= :POST (:method request)
              assert= (Option :some |payload) (:body request)
              assert= (Option :some 7) (:body-length request)
          _
            do
              assert= :GET (:method request)
              assert= (Option :none) (:body request)
              assert= (Option :some |1) (get (:query request) :x)
        let
            headers $ decode-map-as
              {} (:content-type |text/plain) (|x-typed-smoke |yes)
              Map http.core/HeaderName String
          Response :code 200 :headers headers :body |ffi-ok
  reset! task-ref $ Option :some task
  , task'
elif [[ "${1:-}" == default ]]; then
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

if [[ "${1:-}" == typed ]]; then
  post="$(curl --noproxy '*' --fail --silent --max-time 2 -D "$smoke_dir/headers" \
    --data-binary payload "http://127.0.0.1:$port/ffi-post")"
  [[ "$post" == ffi-ok ]]
  grep -iq '^x-typed-smoke: yes' "$smoke_dir/headers"
fi

if [[ "${1:-}" == default || "${1:-}" == typed ]]; then
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

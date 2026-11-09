---
title: "HTTP server response capabilities"
summary: "Serve HTTP requests with exactly-once responses, bounded timeouts, cancellable server tasks, and explicit application boundaries"
scope: "module"
kind: "guide"
category: "ecosystem"
aliases:
  - "calcit http"
  - "HTTP server"
  - "response timeout"
  - "exactly once response"
  - "cancel server"
  - "serve-http"
entry_for:
  - "http.core/serve-http!"
  - "http.core/serve-http-typed!"
  - "response-timeout-ms"
  - "FfiResponse"
---

# HTTP server response capabilities

`http.core/serve-http!` starts a native HTTP listener and returns a cancellable `FfiTask`. Each accepted request owns one response capability. Resolve it exactly once; unresolved requests are rejected when `:response-timeout-ms` expires.

```cirru.no-check
def server-task $ http.core/serve-http!
  Option :some $ decode-map-as
    {} (:host |0.0.0.0) (:port 4000) (:response-timeout-ms 30000)
    Map Tag http.core/ServerOptionValue
  fn (request)
    {} (:code 200)
      :headers $ {} $ :content-type |application/json
      :body |{ ok :true}

server-task.cancel-with! :shutdown
```

## Request and response contract

Requests expose method, URL/path, query, headers, and body fields. Responses use numeric `:code`, string-valued `:headers`, and a string `:body`. Validate external input before passing it into typed business logic.

## Typed requests and responses

`http.core/serve-http-typed!` accepts the same optional configuration and returns the same cancellable `FfiTask` as `serve-http!`. Its callback receives an `http.core/Request` and returns an `http.core/Response`.

The request body, body length, and remote address are `Option` fields. Response header names can be Tag or String, and values must be String. The response is encoded to the existing native response map.

```cirru.no-run
http.core/serve-http-typed! (Option :none)
  fn (request)
    hint-fn $ Fn http.core/Request $ -> http.core/Response
    http.core/Response :code 200 :headers ({}) :body $ :path request
```

## Lifecycle rules

- Keep the returned server task until shutdown and cancel it deliberately.
- Never retain request response capabilities in durable application state.
- Bound application work below the response timeout and map failures to explicit HTTP responses.
- Cancellation stops the listener and interrupts request-event delivery even while the host queue is full.
- After cancellation, the server still publishes one terminal event; the host uses it to reject and release every unresolved response capability exactly once.
- Put authentication, routing, schema validation, and database transactions in application code.

For realtime applications, use HTTP for snapshots, health, or administrative capabilities while WebSocket carries revisioned incremental messages.

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
  - "response-timeout-ms"
  - "FfiResponse"
---

# HTTP server response capabilities

`http.core/serve-http!` starts a native HTTP listener and returns a cancellable `FfiTask`. Each accepted request owns one response capability. Resolve it exactly once; unresolved requests are rejected when `:response-timeout-ms` expires.

```cirru.no-check
def server-task $ http.core/serve-http!
  {} (:host |0.0.0.0) (:port 4000) (:response-timeout-ms 30000)
  fn (request)
    {} (:code 200)
      :headers $ {} (:content-type |application/json)
      :body |{"ok":true}

server-task.cancel-with :shutdown
```

## Request and response contract

Requests expose method, URL/path, query, headers, and body fields. Responses use numeric `:code`, string-valued `:headers`, and a string `:body`. Validate external input before passing it into typed business logic.

## Lifecycle rules

- Keep the returned server task until shutdown and cancel it deliberately.
- Never retain request response capabilities in durable application state.
- Bound application work below the response timeout and map failures to explicit HTTP responses.
- Cancellation stops the listener and queued request events while preserving terminal cleanup.
- Put authentication, routing, schema validation, and database transactions in application code.

For realtime applications, use HTTP for snapshots, health, or administrative capabilities while WebSocket carries revisioned incremental messages.

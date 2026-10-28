
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |http
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'http.test/main!) (:mode :native) (:reload-fn 'http.test/reload!) (:target :native)
      :feature-policy $ {}
      :modules $ []
      :type-slots $ {}
    :server $ {} (:description |) (:init-fn 'http.test/demo-server!) (:mode :native) (:reload-fn 'http.test/reload!) (:target :native)
      :feature-policy $ {}
      :modules $ []
      :type-slots $ {}
  :files $ {}
    'http.core $ %{} 'FileEntry
      :defs $ {}
        'native-smoke $ %{} 'CodeEntry
          :doc "|Internal native ABI smoke probe used by this module test entry. It loads the HTTP dylib and returns a stable token."
          :code $ quote $ defn native-smoke ()
            let
                value $ &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_http) |smoke_ping
              if (string? value) value $ raise "|HTTP native smoke expected a String"
          :examples $ []
          :schema $ quote $ Fn (-> String)
        'serve-http! $ %{} 'CodeEntry
          :doc "|Starts a cancellable native HTTP server through the C-safe async FFI. Params: options (nil or map with :port, :host, and optional :response-timeout-ms), f (request map -> response map). Returns FfiTask; cancel it with .cancel! or .cancel-with!."
          :code $ quote $ defn serve-http! (options f)
            ffi:task $ &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |serve_http options $ fn (request response!)
              let
                  response $ ffi:response response!
                response.resolve! $ f $ decode-map-as request (:: 'Map 'Tag 'Dynamic)
          :examples $ [] $ quote
            serve-http!
              {} (:port 4000) (:host |0.0.0.0)
              fn (req)
                {} (:code 200)
                  :headers $ {} $ :content-type |application/json
                  :body |ok
          :schema $ quote $ Fn Dynamic
            Fn (Map Tag Dynamic)
              -> $ Map Tag Dynamic
            -> calcit.core/FfiTask
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns http.core
          :require
            http.$meta :refer $ calcit-dirname
            http.util :refer $ get-dylib-path
    'http.test $ %{} 'FileEntry
      :defs $ {}
        'demo-server! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn demo-server! ()
            serve-http!
              {} $ :port 4000
              fn (req) (on-request req)
          :examples $ []
          :schema $ quote $ Fn (-> calcit.core/FfiTask)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (run-tests)
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'mid-call $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn mid-call () (println "|Calling internal function") &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'on-request $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-request (req) (; println "|Handling request:" req) (; mid-call)
            {} (:status :ok) (:code 200)
              :headers $ {} $ :content-type |application/json
              :body $ format-cirru-edn req
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
            :features :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (println |Reload) &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'run-tests $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn run-tests () (println "|%%%% test for lib") (println calcit-filename calcit-dirname)
            assert |native-smoke-must-match $ = |calcit-http-native-ok $ native-smoke
            println "|No tests..."
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns http.test
          :require
            http.core :refer $ serve-http! native-smoke
            http.$meta :refer $ calcit-dirname calcit-filename
    'http.util $ %{} 'FileEntry
      :defs $ {}
        'get-dylib-ext $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro get-dylib-ext ()
            match (&get-os) (:macos |.dylib) (:windows |.dll) (_ |.so)
          :examples $ []
          :schema $ quote $ Macro
            -> $ Expr String
            :capabilities :platform-read
        'get-dylib-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-dylib-path (p)
            str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
          :schema $ quote $ Fn String (-> String)
        'or-current-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn or-current-path (p)
            if (blank? p) |. p
          :examples $ []
          :schema $ quote $ Fn String (-> String)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns http.util
          :require $ http.$meta :refer $ calcit-dirname calcit-filename

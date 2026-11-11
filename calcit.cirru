
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
        'HeaderName $ %{} 'CodeEntry
          :doc "|Response header names accepted by the native binding."
          :code $ quote $ defunion HeaderName Tag String
          :examples $ []
          :schema $ quote UnionDef
        'Request $ %{} 'CodeEntry
          :doc "|Checked request fields produced by the native HTTP binding."
          :code $ quote $ defstruct Request (:method Tag) (:url String) (:path String) (:querystring String)
            :query $ Map Tag String
            :headers $ Map Tag String
            :secure Bool
            :body-length $ Option Number
            :remote-addr $ Option String
            :body $ Option String
          :examples $ []
          :schema $ quote StructDef
        'Response $ %{} 'CodeEntry
          :doc "|A typed response encoded to the existing native response map."
          :code $ quote $ defstruct Response (:code Number)
            :headers $ Map http.core/HeaderName String
            :body String
          :examples $ []
          :schema $ quote StructDef
        'ResponseWireValue $ %{} 'CodeEntry
          :doc "|Values emitted to the native binding by the typed response adapter."
          :code $ quote $ defunion ResponseWireValue Number String (Map http.core/HeaderName String)
          :examples $ []
          :schema $ quote UnionDef
        'ServerOptionValue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ServerOptionValue Number String
          :examples $ []
          :schema $ quote UnionDef
        'decode-request $ %{} 'CodeEntry
          :doc "|Normalize nullable native fields before the checked request conversion."
          :code $ quote $ defn decode-request (raw)
            let
                length $ .and-then (get raw :body-length) nil->option
                address $ .and-then (get raw :remote-addr) nil->option
                normalized $ if (.none? length) (dissoc raw :body-length) raw
              decode-map-as
                if (.none? address) (dissoc normalized :remote-addr) normalized
                , http.core/Request
          :examples $ []
          :schema $ quote $ Fn (Map Tag V) (-> Request) (:generics V)
        'native-smoke $ %{} 'CodeEntry
          :doc "|Internal native ABI smoke probe used by this module test entry. It loads the HTTP dylib and returns a stable token."
          :code $ quote $ defn native-smoke ()
            let
                value $ &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_http) |smoke_ping
              if (string? value) value $ raise "|HTTP native smoke expected a String"
          :examples $ []
          :schema $ quote $ Fn (-> String)
        'serve-http! $ %{} 'CodeEntry
          :doc "|Starts a cancellable native HTTP server. Pass Option :none for defaults or Option :some with a Tag-keyed configuration map. The request and response maps cross the native FFI boundary. Cancel the returned FfiTask with .cancel! or .cancel-with!."
          :code $ quote $ defn serve-http! (options f)
            ffi:task $ &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |serve_http
              .unwrap-or options $ {}
              fn (request response!)
                let
                    response $ ffi:response response!
                  response.resolve! $ f $ decode-map-as request (Map Tag Dynamic)
          :examples $ [] $ quote
            serve-http!
              Some $ decode-map-as
                {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
                Map Tag http.core/ServerOptionValue
              fn (req)
                {} (:code 200)
                  :headers $ {} $ :content-type |application/json
                  :body |ok
          :schema $ quote $ Fn
            Option $ Map Tag ServerOptionValue
            Fn (Map Tag Dynamic)
              -> $ Map Tag V
            -> FfiTask
            :generics V
            :features :js-ffi
        'serve-http-typed! $ %{} 'CodeEntry
          :doc "|Serve checked Request values and send Response values with the same native ABI and cancellation semantics as serve-http!."
          :code $ quote $ defn serve-http-typed! (options handler)
            serve-http! options $ fn (raw)
              hint-fn $ Fn (Map Tag Dynamic)
                -> $ Map Tag ResponseWireValue
              let
                  response $ handler $ decode-request raw
                assert-type
                  {}
                    :code $ :code response
                    :headers $ :headers response
                    :body $ :body response
                  Map Tag ResponseWireValue
          :examples $ []
          :schema $ quote $ Fn
            Option $ Map Tag ServerOptionValue
            Fn Request $ -> Response
            -> FfiTask
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns http.core
          :require
            http.$meta :refer $ calcit-dirname
            http.util :refer $ get-dylib-path
    'http.test $ %{} 'FileEntry
      :defs $ {}
        'EchoResponseValue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion EchoResponseValue Tag Number String (Map Tag String)
          :examples $ []
          :schema $ quote UnionDef
        'demo-server! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn demo-server! ()
            serve-http!
              Some $ decode-map-as
                {} (:port 4000) (:host |0.0.0.0) (:response-timeout-ms 30000)
                Map Tag http.core/ServerOptionValue
              fn (req) (on-request req)
          :examples $ []
          :schema $ quote $ Fn (-> FfiTask)
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
            assert-type
              {} (:status :ok) (:code 200)
                :headers $ {} $ :content-type |application/json
                :body $ format-cirru-edn req
              Map Tag EchoResponseValue
          :examples $ []
          :schema $ quote $ Fn (Map Tag V)
            -> $ Map Tag EchoResponseValue
            :generics V
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

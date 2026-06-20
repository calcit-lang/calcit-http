
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |http)
  :configs $ {} (:init-fn |http.test/main!) (:reload-fn |http.test/reload!) (:version |0.3.1)
    :modules $ []
  :entries $ {}
    :server $ {} (:init-fn |http.test/demo-server!) (:reload-fn |http.test/reload!) (:version |0.0.0)
      :modules $ []
  :files $ {}
    |http.core $ %{} :FileEntry
      :defs $ {}
        |serve-http! $ %{} :CodeEntry (:doc "|Starts a native HTTP server through the Rust dylib. Params: options (nil or map with :port and :host), f (request handler receiving a request map and returning a response map). Returns: unit while server loop runs.")
          :code $ quote
            defn serve-http! (options f)
              &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |serve_http options f
          :examples $ []
            quote $ serve-http!
              {} (:port 4000) (:host |0.0.0.0)
              fn (req)
                {} (:code 200)
                  :headers $ {} (:content-type |application/json)
                  :body |ok
          :schema $ :: :fn
            {} (:return :unit)
              :args $ [] :dynamic
                :: :fn $ {} (:return :dynamic)
                  :args $ [] :dynamic
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns http.core $ :require
            http.$meta :refer $ calcit-dirname
            http.util :refer $ get-dylib-path
    |http.test $ %{} :FileEntry
      :defs $ {}
        |demo-server! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn demo-server! () $ serve-http!
              {} $ :port 4000
              fn (req) (on-request req)
          :examples $ []
        |main! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn main! () $ run-tests
          :examples $ []
        |mid-call $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn mid-call () $ println "|Calling internal function"
          :examples $ []
        |on-request $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn on-request (req) (; println "|Handling request:" req)
              println $ :url req
              ; mid-call
              {} (:status :ok) (:code 200)
                :headers $ {} (:content-type |application/json)
                :body $ format-cirru-edn req
          :examples $ []
        |reload! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn reload! () $ println |Reload
          :examples $ []
        |run-tests $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn run-tests () (println "|%%%% test for lib") (println calcit-filename calcit-dirname) (println "|No tests...")
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns http.test $ :require
            http.core :refer $ serve-http!
            http.$meta :refer $ calcit-dirname calcit-filename
    |http.util $ %{} :FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) |.so (:macos |.dylib) (:windows |.dll)
          :examples $ []
        |get-dylib-path $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
        |or-current-path $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn or-current-path (p)
              if (blank? p) |. p
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns http.util $ :require
            http.$meta :refer $ calcit-dirname calcit-filename

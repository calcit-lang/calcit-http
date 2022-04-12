
{} (:package |http)
  :configs $ {} (:init-fn |http.test/main!) (:reload-fn |http.test/reload!)
    :modules $ []
    :version |0.0.6
  :entries $ {}
    :server $ {} (:init-fn |http.test/demo-server!) (:reload-fn |http.test/reload!)
      :modules $ []
  :files $ {}
    |http.core $ {}
      :ns $ quote
        ns http.core $ :require
          http.$meta :refer $ calcit-dirname
          http.util :refer $ get-dylib-path
      :defs $ {}
        |serve-http! $ quote
          defn serve-http! (options f)
            &call-dylib-edn-fn (get-dylib-path "\"/dylibs/libcalcit_http") "\"serve_http" options f
    |http.test $ {}
      :ns $ quote
        ns http.test $ :require
          http.core :refer $ serve-http!
          http.$meta :refer $ calcit-dirname calcit-filename
      :defs $ {}
        |mid-call $ quote
          defn mid-call () $ println "\"Calling internal function"
        |on-request $ quote
          defn on-request (req) (; println "\"Handling request:" req)
            println $ :url req
            ; mid-call
            {} (:status :ok) (:code 200)
              :headers $ {} (:content-type "\"application/json")
              :body $ format-cirru-edn req
        |run-tests $ quote
          defn run-tests () (println "\"%%%% test for lib") (println calcit-filename calcit-dirname) (println "\"No tests...")
        |main! $ quote
          defn main! () $ run-tests
        |demo-server! $ quote
          defn demo-server! () $ serve-http!
            {} $ :port 4000
            fn (req) (on-request req)
        |reload! $ quote
          defn reload! () $ println "\"Reload"
    |http.util $ {}
      :ns $ quote
        ns http.util $ :require
          http.$meta :refer $ calcit-dirname calcit-filename
      :defs $ {}
        |get-dylib-ext $ quote
          defmacro get-dylib-ext () $ case-default (&get-os) "\".so" (:macos "\".dylib") (:windows "\".dll")
        |get-dylib-path $ quote
          defn get-dylib-path (p)
            str (or-current-path calcit-dirname) p $ get-dylib-ext
        |or-current-path $ quote
          defn or-current-path (p)
            if (blank? p) "\"." p

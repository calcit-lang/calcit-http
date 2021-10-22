
{} (:package |http)
  :configs $ {} (:init-fn |http.test/main!) (:reload-fn |http.test/reload!)
    :modules $ []
    :version |0.0.3
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
        |run-tests $ quote
          defn run-tests () (println "\"%%%% test for lib") (println calcit-filename calcit-dirname) (println "\"No tests...")
        |main! $ quote
          defn main! () $ run-tests
        |demo-server! $ quote
          defn demo-server! () $ serve-http!
            {} $ :port 4000
            fn (req) (println "\"got request" req)
              {} (:status :ok) (:code 200) (:body "\"TODO some Body")
        |reload! $ quote
          defn reload! $
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

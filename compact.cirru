
{} (:package |http)
  :configs $ {} (:init-fn |http.test/main!) (:reload-fn |http.test/reload!) (:version |0.2.0)
    :modules $ []
  :entries $ {}
    :server $ {} (:init-fn |http.test/demo-server!) (:reload-fn |http.test/reload!)
      :modules $ []
  :files $ {}
    |http.core $ {}
      :defs $ {}
        |serve-http! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn serve-http! (options f)
              &call-dylib-edn-fn (get-dylib-path "\"/dylibs/libcalcit_http") "\"serve_http" options f
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns http.core $ :require
            http.$meta :refer $ calcit-dirname
            http.util :refer $ get-dylib-path
    |http.test $ {}
      :defs $ {}
        |demo-server! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn demo-server! () $ serve-http!
              {} $ :port 4000
              fn (req) (on-request req)
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! () $ run-tests
        |mid-call $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn mid-call () $ println "\"Calling internal function"
        |on-request $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-request (req) (; println "\"Handling request:" req)
              println $ :url req
              ; mid-call
              {} (:status :ok) (:code 200)
                :headers $ {} (:content-type "\"application/json")
                :body $ format-cirru-edn req
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ println "\"Reload"
        |run-tests $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn run-tests () (println "\"%%%% test for lib") (println calcit-filename calcit-dirname) (println "\"No tests...")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns http.test $ :require
            http.core :refer $ serve-http!
            http.$meta :refer $ calcit-dirname calcit-filename
    |http.util $ {}
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc |)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) "\".so" (:macos "\".dylib") (:windows "\".dll")
        |get-dylib-path $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
        |or-current-path $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn or-current-path (p)
              if (blank? p) "\"." p
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns http.util $ :require
            http.$meta :refer $ calcit-dirname calcit-filename

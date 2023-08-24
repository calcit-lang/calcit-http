
{} (:package |http)
  :configs $ {} (:init-fn |http.test/main!) (:port 6001) (:reload-fn |http.test/reload!) (:version |0.2.0)
    :modules $ []
  :entries $ {}
    :server $ {} (:init-fn |http.test/demo-server!) (:reload-fn |http.test/reload!)
      :modules $ []
  :files $ {}
    |http.core $ {}
      :configs $ {}
      :defs $ {}
        |serve-http! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630219258753) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630219258753) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1634925773988) (:by |u0) (:text |serve-http!)
              |r $ %{} :Expr (:at 1630219268038) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634925832821) (:by |u0) (:text |options)
                  |j $ %{} :Leaf (:at 1634925803119) (:by |u0) (:text |f)
              |v $ %{} :Expr (:at 1630219268038) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634925994556) (:by |u0) (:text |&call-dylib-edn-fn)
                  |b $ %{} :Expr (:at 1634804189975) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634804196083) (:by |u0) (:text |get-dylib-path)
                      |j $ %{} :Leaf (:at 1634925786578) (:by |u0) (:text "|\"/dylibs/libcalcit_http")
                  |r $ %{} :Leaf (:at 1634925778561) (:by |u0) (:text "|\"serve_http")
                  |v $ %{} :Leaf (:at 1634925835824) (:by |u0) (:text |options)
                  |x $ %{} :Leaf (:at 1634925807507) (:by |u0) (:text |f)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1630171366222) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |http.core)
            |r $ %{} :Expr (:at 1630175118985) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1630175119637) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1630175120856) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925748814) (:by |u0) (:text |http.$meta)
                    |j $ %{} :Leaf (:at 1630175127717) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1630175128076) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630175130627) (:by |u0) (:text |calcit-dirname)
                |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925750636) (:by |u0) (:text |http.util)
                    |j $ %{} :Leaf (:at 1633181140100) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634804181370) (:by |u0) (:text |get-dylib-path)
    |http.test $ {}
      :configs $ {}
      :defs $ {}
        |demo-server! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1634925851472) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1634925851472) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1634925851472) (:by |u0) (:text |demo-server!)
              |r $ %{} :Expr (:at 1634925851472) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1634925862141) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634925862536) (:by |u0) (:text |serve-http!)
                  |j $ %{} :Expr (:at 1634925864149) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925864550) (:by |u0) (:text |{})
                      |j $ %{} :Expr (:at 1634925865947) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634925868491) (:by |u0) (:text |:port)
                          |j $ %{} :Leaf (:at 1634925873265) (:by |u0) (:text |4000)
                  |r $ %{} :Expr (:at 1634925875730) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925876073) (:by |u0) (:text |fn)
                      |j $ %{} :Expr (:at 1634925876370) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634925879038) (:by |u0) (:text |req)
                      |u $ %{} :Expr (:at 1635234343570) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635234354812) (:by |u0) (:text |on-request)
                          |j $ %{} :Leaf (:at 1635234348198) (:by |u0) (:text |req)
        |main! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633149996242) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |main!)
              |r $ %{} :Expr (:at 1633149996242) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1633150002066) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1633150004371) (:by |u0) (:text |run-tests)
        |mid-call $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1634927786817) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1634927788771) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1635228168857) (:by |u0) (:text |mid-call)
              |r $ %{} :Expr (:at 1634927786817) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1634927789650) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634927790523) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1635228176331) (:by |u0) (:text "|\"Calling internal function")
        |on-request $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1635234356153) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |on-request)
              |r $ %{} :Expr (:at 1635234356153) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |req)
              |s $ %{} :Expr (:at 1635234372099) (:by |u0)
                :data $ {}
                  |L $ %{} :Leaf (:at 1649937276422) (:by |u0) (:text |;)
                  |j $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text |println)
                  |r $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text "|\"Handling request:")
                  |v $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text |req)
              |sT $ %{} :Expr (:at 1635234439960) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635234441166) (:by |u0) (:text |println)
                  |j $ %{} :Expr (:at 1635234441792) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635234442744) (:by |u0) (:text |:url)
                      |j $ %{} :Leaf (:at 1635234443443) (:by |u0) (:text |req)
              |t $ %{} :Expr (:at 1635234365546) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635234365546) (:by |u0) (:text |;)
                  |j $ %{} :Leaf (:at 1635234365546) (:by |u0) (:text |mid-call)
              |v $ %{} :Expr (:at 1635234357410) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |{})
                  |j $ %{} :Expr (:at 1635234357410) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:status)
                      |j $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:ok)
                  |r $ %{} :Expr (:at 1635234357410) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:code)
                      |j $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |200)
                  |t $ %{} :Expr (:at 1635234527621) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635234530563) (:by |u0) (:text |:headers)
                      |j $ %{} :Expr (:at 1635234530868) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635234531808) (:by |u0) (:text |{})
                          |j $ %{} :Expr (:at 1635234532157) (:by |u0)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1635234534604) (:by |u0) (:text |:content-type)
                              |j $ %{} :Leaf (:at 1649936690797) (:by |u0) (:text "|\"application/json")
                  |v $ %{} :Expr (:at 1635234357410) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:body)
                      |j $ %{} :Expr (:at 1635234494733) (:by |u0)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1635234502294) (:by |u0) (:text |format-cirru-edn)
                          |L $ %{} :Leaf (:at 1635234496887) (:by |u0) (:text |req)
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633149998862) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |reload!)
              |r $ %{} :Expr (:at 1633149998862) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1635234381868) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635234382819) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1635234384199) (:by |u0) (:text "|\"Reload")
        |run-tests $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633150008092) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633150011172) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633150008092) (:by |u0) (:text |run-tests)
              |r $ %{} :Expr (:at 1633150008092) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1634703837934) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634703847178) (:by |u0) (:text "|\"%%%% test for lib")
              |x $ %{} :Expr (:at 1634703837934) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-filename)
                  |r $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-dirname)
              |y $ %{} :Expr (:at 1634925705832) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634925706714) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634925710662) (:by |u0) (:text "|\"No tests...")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1633149625774) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |http.test)
            |r $ %{} :Expr (:at 1633149974572) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1633149975596) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1634703855566) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925723309) (:by |u0) (:text |http.core)
                    |j $ %{} :Leaf (:at 1634703859915) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634925717139) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634925857666) (:by |u0) (:text |serve-http!)
                |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925725264) (:by |u0) (:text |http.$meta)
                    |j $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |calcit-dirname)
                        |j $ %{} :Leaf (:at 1634703953240) (:by |u0) (:text |calcit-filename)
    |http.util $ {}
      :configs $ {}
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630231398718) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630231418304) (:by |u0) (:text |defmacro)
              |j $ %{} :Leaf (:at 1633181058353) (:by |u0) (:text |get-dylib-ext)
              |r $ %{} :Expr (:at 1630231398718) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1630231403270) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630231423910) (:by |u0) (:text |case-default)
                  |b $ %{} :Expr (:at 1630231429893) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231433951) (:by |u0) (:text |&get-os)
                  |j $ %{} :Leaf (:at 1630231427453) (:by |u0) (:text "|\".so")
                  |r $ %{} :Expr (:at 1630231437150) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231439152) (:by |u0) (:text |:macos)
                      |j $ %{} :Leaf (:at 1630231447585) (:by |u0) (:text "|\".dylib")
                  |v $ %{} :Expr (:at 1630231448478) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231449901) (:by |u0) (:text |:windows)
                      |j $ %{} :Leaf (:at 1630231461388) (:by |u0) (:text "|\".dll")
        |get-dylib-path $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1634804142034) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1634804142034) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1634804142034) (:by |u0) (:text |get-dylib-path)
              |n $ %{} :Expr (:at 1634804146574) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634804230294) (:by |u0) (:text |p)
              |r $ %{} :Expr (:at 1634804145483) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |str)
                  |j $ %{} :Expr (:at 1634804145483) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |or-current-path)
                      |j $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |calcit-dirname)
                  |r $ %{} :Leaf (:at 1634804157377) (:by |u0) (:text |p)
                  |v $ %{} :Expr (:at 1634804145483) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |get-dylib-ext)
        |or-current-path $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630245582276) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630245583936) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633181131099) (:by |u0) (:text |or-current-path)
              |r $ %{} :Expr (:at 1630245582276) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630245585364) (:by |u0) (:text |p)
              |v $ %{} :Expr (:at 1630245585942) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630245586336) (:by |u0) (:text |if)
                  |j $ %{} :Expr (:at 1630245586894) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630245614560) (:by |u0) (:text |blank?)
                      |j $ %{} :Leaf (:at 1630245615061) (:by |u0) (:text |p)
                  |r $ %{} :Leaf (:at 1630245616843) (:by |u0) (:text "|\".")
                  |v $ %{} :Leaf (:at 1630245618366) (:by |u0) (:text |p)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1633181044360) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |http.util)
            |r $ %{} :Expr (:at 1634804160546) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1634804161330) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1634804162771) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925740941) (:by |u0) (:text |http.$meta)
                    |j $ %{} :Leaf (:at 1634804168120) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634804168421) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634804171748) (:by |u0) (:text |calcit-dirname)
                        |j $ %{} :Leaf (:at 1634804175462) (:by |u0) (:text |calcit-filename)
  :ir $ {} (:package |http)
    :files $ {}
      |http.core $ {}
        :configs $ {}
        :defs $ {}
          |serve-http! $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1630219258753) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1630219258753) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1634925773988) (:by |u0) (:text |serve-http!)
                |r $ %{} :Expr (:at 1630219268038) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925832821) (:by |u0) (:text |options)
                    |j $ %{} :Leaf (:at 1634925803119) (:by |u0) (:text |f)
                |v $ %{} :Expr (:at 1630219268038) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925994556) (:by |u0) (:text |&call-dylib-edn-fn)
                    |b $ %{} :Expr (:at 1634804189975) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634804196083) (:by |u0) (:text |get-dylib-path)
                        |j $ %{} :Leaf (:at 1634925786578) (:by |u0) (:text "|\"/dylibs/libcalcit_http")
                    |r $ %{} :Leaf (:at 1634925778561) (:by |u0) (:text "|\"serve_http")
                    |v $ %{} :Leaf (:at 1634925835824) (:by |u0) (:text |options)
                    |x $ %{} :Leaf (:at 1634925807507) (:by |u0) (:text |f)
        :ns $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630171366222) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |ns)
              |j $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |http.core)
              |r $ %{} :Expr (:at 1630175118985) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630175119637) (:by |u0) (:text |:require)
                  |j $ %{} :Expr (:at 1630175120856) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925748814) (:by |u0) (:text |http.$meta)
                      |j $ %{} :Leaf (:at 1630175127717) (:by |u0) (:text |:refer)
                      |r $ %{} :Expr (:at 1630175128076) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1630175130627) (:by |u0) (:text |calcit-dirname)
                  |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925750636) (:by |u0) (:text |http.util)
                      |j $ %{} :Leaf (:at 1633181140100) (:by |u0) (:text |:refer)
                      |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634804181370) (:by |u0) (:text |get-dylib-path)
      |http.test $ {}
        :configs $ {}
        :defs $ {}
          |demo-server! $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1634925851472) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1634925851472) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1634925851472) (:by |u0) (:text |demo-server!)
                |r $ %{} :Expr (:at 1634925851472) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1634925862141) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925862536) (:by |u0) (:text |serve-http!)
                    |j $ %{} :Expr (:at 1634925864149) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634925864550) (:by |u0) (:text |{})
                        |j $ %{} :Expr (:at 1634925865947) (:by |u0)
                          :data $ {}
                            |T $ %{} :Leaf (:at 1634925868491) (:by |u0) (:text |:port)
                            |j $ %{} :Leaf (:at 1634925873265) (:by |u0) (:text |4000)
                    |r $ %{} :Expr (:at 1634925875730) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634925876073) (:by |u0) (:text |fn)
                        |j $ %{} :Expr (:at 1634925876370) (:by |u0)
                          :data $ {}
                            |T $ %{} :Leaf (:at 1634925879038) (:by |u0) (:text |req)
                        |u $ %{} :Expr (:at 1635234343570) (:by |u0)
                          :data $ {}
                            |T $ %{} :Leaf (:at 1635234354812) (:by |u0) (:text |on-request)
                            |j $ %{} :Leaf (:at 1635234348198) (:by |u0) (:text |req)
          |main! $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1633149996242) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |main!)
                |r $ %{} :Expr (:at 1633149996242) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1633150002066) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1633150004371) (:by |u0) (:text |run-tests)
          |mid-call $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1634927786817) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1634927788771) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1635228168857) (:by |u0) (:text |mid-call)
                |r $ %{} :Expr (:at 1634927786817) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1634927789650) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634927790523) (:by |u0) (:text |println)
                    |j $ %{} :Leaf (:at 1635228176331) (:by |u0) (:text "|\"Calling internal function")
          |on-request $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1635234356153) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |on-request)
                |r $ %{} :Expr (:at 1635234356153) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1635234356153) (:by |u0) (:text |req)
                |s $ %{} :Expr (:at 1635234372099) (:by |u0)
                  :data $ {}
                    |L $ %{} :Leaf (:at 1649937276422) (:by |u0) (:text |;)
                    |j $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text |println)
                    |r $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text "|\"Handling request:")
                    |v $ %{} :Leaf (:at 1635234372099) (:by |u0) (:text |req)
                |sT $ %{} :Expr (:at 1635234439960) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1635234441166) (:by |u0) (:text |println)
                    |j $ %{} :Expr (:at 1635234441792) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1635234442744) (:by |u0) (:text |:url)
                        |j $ %{} :Leaf (:at 1635234443443) (:by |u0) (:text |req)
                |t $ %{} :Expr (:at 1635234365546) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1635234365546) (:by |u0) (:text |;)
                    |j $ %{} :Leaf (:at 1635234365546) (:by |u0) (:text |mid-call)
                |v $ %{} :Expr (:at 1635234357410) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |{})
                    |j $ %{} :Expr (:at 1635234357410) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:status)
                        |j $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:ok)
                    |r $ %{} :Expr (:at 1635234357410) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:code)
                        |j $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |200)
                    |t $ %{} :Expr (:at 1635234527621) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1635234530563) (:by |u0) (:text |:headers)
                        |j $ %{} :Expr (:at 1635234530868) (:by |u0)
                          :data $ {}
                            |T $ %{} :Leaf (:at 1635234531808) (:by |u0) (:text |{})
                            |j $ %{} :Expr (:at 1635234532157) (:by |u0)
                              :data $ {}
                                |T $ %{} :Leaf (:at 1635234534604) (:by |u0) (:text |:content-type)
                                |j $ %{} :Leaf (:at 1649936690797) (:by |u0) (:text "|\"application/json")
                    |v $ %{} :Expr (:at 1635234357410) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1635234357410) (:by |u0) (:text |:body)
                        |j $ %{} :Expr (:at 1635234494733) (:by |u0)
                          :data $ {}
                            |D $ %{} :Leaf (:at 1635234502294) (:by |u0) (:text |format-cirru-edn)
                            |L $ %{} :Leaf (:at 1635234496887) (:by |u0) (:text |req)
          |reload! $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1633149998862) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |reload!)
                |r $ %{} :Expr (:at 1633149998862) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1635234381868) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1635234382819) (:by |u0) (:text |println)
                    |j $ %{} :Leaf (:at 1635234384199) (:by |u0) (:text "|\"Reload")
          |run-tests $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1633150008092) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1633150011172) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1633150008092) (:by |u0) (:text |run-tests)
                |r $ %{} :Expr (:at 1633150008092) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1634703837934) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                    |j $ %{} :Leaf (:at 1634703847178) (:by |u0) (:text "|\"%%%% test for lib")
                |x $ %{} :Expr (:at 1634703837934) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                    |j $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-filename)
                    |r $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-dirname)
                |y $ %{} :Expr (:at 1634925705832) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634925706714) (:by |u0) (:text |println)
                    |j $ %{} :Leaf (:at 1634925710662) (:by |u0) (:text "|\"No tests...")
        :ns $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633149625774) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |ns)
              |j $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |http.test)
              |r $ %{} :Expr (:at 1633149974572) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1633149975596) (:by |u0) (:text |:require)
                  |j $ %{} :Expr (:at 1634703855566) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925723309) (:by |u0) (:text |http.core)
                      |j $ %{} :Leaf (:at 1634703859915) (:by |u0) (:text |:refer)
                      |r $ %{} :Expr (:at 1634925717139) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634925857666) (:by |u0) (:text |serve-http!)
                  |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925725264) (:by |u0) (:text |http.$meta)
                      |j $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |:refer)
                      |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |calcit-dirname)
                          |j $ %{} :Leaf (:at 1634703953240) (:by |u0) (:text |calcit-filename)
      |http.util $ {}
        :configs $ {}
        :defs $ {}
          |get-dylib-ext $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1630231398718) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1630231418304) (:by |u0) (:text |defmacro)
                |j $ %{} :Leaf (:at 1633181058353) (:by |u0) (:text |get-dylib-ext)
                |r $ %{} :Expr (:at 1630231398718) (:by |u0)
                  :data $ {}
                |v $ %{} :Expr (:at 1630231403270) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1630231423910) (:by |u0) (:text |case-default)
                    |b $ %{} :Expr (:at 1630231429893) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630231433951) (:by |u0) (:text |&get-os)
                    |j $ %{} :Leaf (:at 1630231427453) (:by |u0) (:text "|\".so")
                    |r $ %{} :Expr (:at 1630231437150) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630231439152) (:by |u0) (:text |:macos)
                        |j $ %{} :Leaf (:at 1630231447585) (:by |u0) (:text "|\".dylib")
                    |v $ %{} :Expr (:at 1630231448478) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630231449901) (:by |u0) (:text |:windows)
                        |j $ %{} :Leaf (:at 1630231461388) (:by |u0) (:text "|\".dll")
          |get-dylib-path $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1634804142034) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1634804142034) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1634804142034) (:by |u0) (:text |get-dylib-path)
                |n $ %{} :Expr (:at 1634804146574) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634804230294) (:by |u0) (:text |p)
                |r $ %{} :Expr (:at 1634804145483) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |str)
                    |j $ %{} :Expr (:at 1634804145483) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |or-current-path)
                        |j $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |calcit-dirname)
                    |r $ %{} :Leaf (:at 1634804157377) (:by |u0) (:text |p)
                    |v $ %{} :Expr (:at 1634804145483) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634804145483) (:by |u0) (:text |get-dylib-ext)
          |or-current-path $ %{} :CodeEntry (:doc |)
            :code $ %{} :Expr (:at 1630245582276) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1630245583936) (:by |u0) (:text |defn)
                |j $ %{} :Leaf (:at 1633181131099) (:by |u0) (:text |or-current-path)
                |r $ %{} :Expr (:at 1630245582276) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1630245585364) (:by |u0) (:text |p)
                |v $ %{} :Expr (:at 1630245585942) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1630245586336) (:by |u0) (:text |if)
                    |j $ %{} :Expr (:at 1630245586894) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630245614560) (:by |u0) (:text |blank?)
                        |j $ %{} :Leaf (:at 1630245615061) (:by |u0) (:text |p)
                    |r $ %{} :Leaf (:at 1630245616843) (:by |u0) (:text "|\".")
                    |v $ %{} :Leaf (:at 1630245618366) (:by |u0) (:text |p)
        :ns $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633181044360) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |ns)
              |j $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |http.util)
              |r $ %{} :Expr (:at 1634804160546) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634804161330) (:by |u0) (:text |:require)
                  |j $ %{} :Expr (:at 1634804162771) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634925740941) (:by |u0) (:text |http.$meta)
                      |j $ %{} :Leaf (:at 1634804168120) (:by |u0) (:text |:refer)
                      |r $ %{} :Expr (:at 1634804168421) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1634804171748) (:by |u0) (:text |calcit-dirname)
                          |j $ %{} :Leaf (:at 1634804175462) (:by |u0) (:text |calcit-filename)
  :users $ {}
    |u0 $ {} (:avatar nil) (:id |u0) (:name |chen) (:nickname |chen) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)

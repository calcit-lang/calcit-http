
{}
  :configs $ {} (:init-fn |http.test/main!) (:port 6001) (:reload-fn |http.test/reload!) (:version |0.1.0)
    :modules $ []
  :entries $ {}
    :server $ {} (:init-fn |http.test/demo-server!) (:reload-fn |http.test/reload!)
      :modules $ []
  :ir $ {} (:package |http)
    :files $ {}
      |http.core $ {}
        :configs $ {}
        :defs $ {}
          |serve-http! $ {} (:at 1630219258753) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630219258753) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1634925773988) (:by |u0) (:text |serve-http!) (:type :leaf)
              |r $ {} (:at 1630219268038) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634925832821) (:by |u0) (:text |options) (:type :leaf)
                  |j $ {} (:at 1634925803119) (:by |u0) (:text |f) (:type :leaf)
              |v $ {} (:at 1630219268038) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634925994556) (:by |u0) (:text |&call-dylib-edn-fn) (:type :leaf)
                  |b $ {} (:at 1634804189975) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634804196083) (:by |u0) (:text |get-dylib-path) (:type :leaf)
                      |j $ {} (:at 1634925786578) (:by |u0) (:text "|\"/dylibs/libcalcit_http") (:type :leaf)
                  |r $ {} (:at 1634925778561) (:by |u0) (:text "|\"serve_http") (:type :leaf)
                  |v $ {} (:at 1634925835824) (:by |u0) (:text |options) (:type :leaf)
                  |x $ {} (:at 1634925807507) (:by |u0) (:text |f) (:type :leaf)
        :ns $ {} (:at 1630171366222) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1630171366222) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1630171366222) (:by |u0) (:text |http.core) (:type :leaf)
            |r $ {} (:at 1630175118985) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1630175119637) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1630175120856) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634925748814) (:by |u0) (:text |http.$meta) (:type :leaf)
                    |j $ {} (:at 1630175127717) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1630175128076) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1630175130627) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                |r $ {} (:at 1633181140100) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634925750636) (:by |u0) (:text |http.util) (:type :leaf)
                    |j $ {} (:at 1633181140100) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1633181140100) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634804181370) (:by |u0) (:text |get-dylib-path) (:type :leaf)
        :proc $ {} (:at 1630171366222) (:by |u0) (:type :expr)
          :data $ {}
      |http.test $ {}
        :configs $ {}
        :defs $ {}
          |demo-server! $ {} (:at 1634925851472) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1634925851472) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1634925851472) (:by |u0) (:text |demo-server!) (:type :leaf)
              |r $ {} (:at 1634925851472) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1634925862141) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634925862536) (:by |u0) (:text |serve-http!) (:type :leaf)
                  |j $ {} (:at 1634925864149) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634925864550) (:by |u0) (:text |{}) (:type :leaf)
                      |j $ {} (:at 1634925865947) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1634925868491) (:by |u0) (:text |:port) (:type :leaf)
                          |j $ {} (:at 1634925873265) (:by |u0) (:text |4000) (:type :leaf)
                  |r $ {} (:at 1634925875730) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634925876073) (:by |u0) (:text |fn) (:type :leaf)
                      |j $ {} (:at 1634925876370) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1634925879038) (:by |u0) (:text |req) (:type :leaf)
                      |u $ {} (:at 1635234343570) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635234354812) (:by |u0) (:text |on-request) (:type :leaf)
                          |j $ {} (:at 1635234348198) (:by |u0) (:text |req) (:type :leaf)
          |main! $ {} (:at 1633149996242) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633149996242) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633149996242) (:by |u0) (:text |main!) (:type :leaf)
              |r $ {} (:at 1633149996242) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1633150002066) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1633150004371) (:by |u0) (:text |run-tests) (:type :leaf)
          |mid-call $ {} (:at 1634927786817) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1634927788771) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1635228168857) (:by |u0) (:text |mid-call) (:type :leaf)
              |r $ {} (:at 1634927786817) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1634927789650) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634927790523) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1635228176331) (:by |u0) (:text "|\"Calling internal function") (:type :leaf)
          |on-request $ {} (:at 1635234356153) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1635234356153) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1635234356153) (:by |u0) (:text |on-request) (:type :leaf)
              |r $ {} (:at 1635234356153) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635234356153) (:by |u0) (:text |req) (:type :leaf)
              |s $ {} (:at 1635234372099) (:by |u0) (:type :expr)
                :data $ {}
                  |L $ {} (:at 1649937276422) (:by |u0) (:text |;) (:type :leaf)
                  |j $ {} (:at 1635234372099) (:by |u0) (:text |println) (:type :leaf)
                  |r $ {} (:at 1635234372099) (:by |u0) (:text "|\"Handling request:") (:type :leaf)
                  |v $ {} (:at 1635234372099) (:by |u0) (:text |req) (:type :leaf)
              |sT $ {} (:at 1635234439960) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635234441166) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1635234441792) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635234442744) (:by |u0) (:text |:url) (:type :leaf)
                      |j $ {} (:at 1635234443443) (:by |u0) (:text |req) (:type :leaf)
              |t $ {} (:at 1635234365546) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635234365546) (:by |u0) (:text |;) (:type :leaf)
                  |j $ {} (:at 1635234365546) (:by |u0) (:text |mid-call) (:type :leaf)
              |v $ {} (:at 1635234357410) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635234357410) (:by |u0) (:text |{}) (:type :leaf)
                  |j $ {} (:at 1635234357410) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635234357410) (:by |u0) (:text |:status) (:type :leaf)
                      |j $ {} (:at 1635234357410) (:by |u0) (:text |:ok) (:type :leaf)
                  |r $ {} (:at 1635234357410) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635234357410) (:by |u0) (:text |:code) (:type :leaf)
                      |j $ {} (:at 1635234357410) (:by |u0) (:text |200) (:type :leaf)
                  |t $ {} (:at 1635234527621) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635234530563) (:by |u0) (:text |:headers) (:type :leaf)
                      |j $ {} (:at 1635234530868) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635234531808) (:by |u0) (:text |{}) (:type :leaf)
                          |j $ {} (:at 1635234532157) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1635234534604) (:by |u0) (:text |:content-type) (:type :leaf)
                              |j $ {} (:at 1649936690797) (:by |u0) (:text "|\"application/json") (:type :leaf)
                  |v $ {} (:at 1635234357410) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635234357410) (:by |u0) (:text |:body) (:type :leaf)
                      |j $ {} (:at 1635234494733) (:by |u0) (:type :expr)
                        :data $ {}
                          |D $ {} (:at 1635234502294) (:by |u0) (:text |format-cirru-edn) (:type :leaf)
                          |L $ {} (:at 1635234496887) (:by |u0) (:text |req) (:type :leaf)
          |reload! $ {} (:at 1633149998862) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633149998862) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633149998862) (:by |u0) (:text |reload!) (:type :leaf)
              |r $ {} (:at 1633149998862) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1635234381868) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635234382819) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1635234384199) (:by |u0) (:text "|\"Reload") (:type :leaf)
          |run-tests $ {} (:at 1633150008092) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633150011172) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633150008092) (:by |u0) (:text |run-tests) (:type :leaf)
              |r $ {} (:at 1633150008092) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1634703837934) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634703837934) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634703847178) (:by |u0) (:text "|\"%%%% test for lib") (:type :leaf)
              |x $ {} (:at 1634703837934) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634703837934) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634703837934) (:by |u0) (:text |calcit-filename) (:type :leaf)
                  |r $ {} (:at 1634703837934) (:by |u0) (:text |calcit-dirname) (:type :leaf)
              |y $ {} (:at 1634925705832) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634925706714) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634925710662) (:by |u0) (:text "|\"No tests...") (:type :leaf)
        :ns $ {} (:at 1633149625774) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1633149625774) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1633149625774) (:by |u0) (:text |http.test) (:type :leaf)
            |r $ {} (:at 1633149974572) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1633149975596) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1634703855566) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634925723309) (:by |u0) (:text |http.core) (:type :leaf)
                    |j $ {} (:at 1634703859915) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634925717139) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634925857666) (:by |u0) (:text |serve-http!) (:type :leaf)
                |r $ {} (:at 1634703941759) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634925725264) (:by |u0) (:text |http.$meta) (:type :leaf)
                    |j $ {} (:at 1634703941759) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634703941759) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634703941759) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                        |j $ {} (:at 1634703953240) (:by |u0) (:text |calcit-filename) (:type :leaf)
        :proc $ {} (:at 1633149625774) (:by |u0) (:type :expr)
          :data $ {}
      |http.util $ {}
        :configs $ {}
        :defs $ {}
          |get-dylib-ext $ {} (:at 1630231398718) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630231418304) (:by |u0) (:text |defmacro) (:type :leaf)
              |j $ {} (:at 1633181058353) (:by |u0) (:text |get-dylib-ext) (:type :leaf)
              |r $ {} (:at 1630231398718) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1630231403270) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630231423910) (:by |u0) (:text |case-default) (:type :leaf)
                  |b $ {} (:at 1630231429893) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231433951) (:by |u0) (:text |&get-os) (:type :leaf)
                  |j $ {} (:at 1630231427453) (:by |u0) (:text "|\".so") (:type :leaf)
                  |r $ {} (:at 1630231437150) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231439152) (:by |u0) (:text |:macos) (:type :leaf)
                      |j $ {} (:at 1630231447585) (:by |u0) (:text "|\".dylib") (:type :leaf)
                  |v $ {} (:at 1630231448478) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231449901) (:by |u0) (:text |:windows) (:type :leaf)
                      |j $ {} (:at 1630231461388) (:by |u0) (:text "|\".dll") (:type :leaf)
          |get-dylib-path $ {} (:at 1634804142034) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1634804142034) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1634804142034) (:by |u0) (:text |get-dylib-path) (:type :leaf)
              |n $ {} (:at 1634804146574) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634804230294) (:by |u0) (:text |p) (:type :leaf)
              |r $ {} (:at 1634804145483) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634804145483) (:by |u0) (:text |str) (:type :leaf)
                  |j $ {} (:at 1634804145483) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634804145483) (:by |u0) (:text |or-current-path) (:type :leaf)
                      |j $ {} (:at 1634804145483) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                  |r $ {} (:at 1634804157377) (:by |u0) (:text |p) (:type :leaf)
                  |v $ {} (:at 1634804145483) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634804145483) (:by |u0) (:text |get-dylib-ext) (:type :leaf)
          |or-current-path $ {} (:at 1630245582276) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630245583936) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633181131099) (:by |u0) (:text |or-current-path) (:type :leaf)
              |r $ {} (:at 1630245582276) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630245585364) (:by |u0) (:text |p) (:type :leaf)
              |v $ {} (:at 1630245585942) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630245586336) (:by |u0) (:text |if) (:type :leaf)
                  |j $ {} (:at 1630245586894) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630245614560) (:by |u0) (:text |blank?) (:type :leaf)
                      |j $ {} (:at 1630245615061) (:by |u0) (:text |p) (:type :leaf)
                  |r $ {} (:at 1630245616843) (:by |u0) (:text "|\".") (:type :leaf)
                  |v $ {} (:at 1630245618366) (:by |u0) (:text |p) (:type :leaf)
        :ns $ {} (:at 1633181044360) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1633181044360) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1633181044360) (:by |u0) (:text |http.util) (:type :leaf)
            |r $ {} (:at 1634804160546) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1634804161330) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1634804162771) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634925740941) (:by |u0) (:text |http.$meta) (:type :leaf)
                    |j $ {} (:at 1634804168120) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634804168421) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634804171748) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                        |j $ {} (:at 1634804175462) (:by |u0) (:text |calcit-filename) (:type :leaf)
        :proc $ {} (:at 1633181044360) (:by |u0) (:type :expr)
          :data $ {}
  :users $ {}
    |u0 $ {} (:avatar nil) (:id |u0) (:name |chen) (:nickname |chen) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)

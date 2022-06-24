(declare-datatypes () ((Vertex A B C D E F G H)))
(declare-fun Edge (Vertex Vertex) Bool)
(declare-fun Reachable (Vertex Vertex) Bool)
(declare-fun Isolated (Vertex) Bool)

; 1. Fully specify the graph by providing the definition of the Edge relation

;(assert (implies (Edge X Y)(A B))) 

(assert (and (= (Edge A B) true)(=> (Edge A B) (not(Edge B A)))))
(assert (and (= (Edge A C) true)(=> (Edge A C) (not(Edge C A)))))
(assert (and (= (Edge B C) true)(=> (Edge B C) (not(Edge C B)))))
(assert (and (= (Edge C D) true)(=> (Edge C D) (not(Edge D C)))))
(assert (and (= (Edge D A) true)(=> (Edge D A) (not(Edge A D)))))
(assert (and (= (Edge C E) true)(=> (Edge C E) (not(Edge E C)))))
(assert (and (= (Edge D E) true)(=> (Edge D E) (not(Edge E D)))))
(assert (and (= (Edge F C) true)(=> (Edge F C) (not(Edge C F)))))
(assert (and (= (Edge F G) true)(=> (Edge F G) (not(Edge G F)))))
(assert (and (= (Edge H F) true)(=> (Edge H F) (not(Edge F H)))))
(assert (and (= (Edge E E) true)))


; 2. Every node can reach itself
(assert (forall ((x Vertex)) (Reachable x x)))

; 3. If there is an edge from x to y and y can reach z then x can reach z
(assert (forall ((x Vertex) (y Vertex) (z Vertex)) (=> (and (Edge x y) (Reachable y z)) (Reachable x z)))) 

; 4. A node is isolated if and only if there is no incoming or outgoing edge
(assert (forall ((x Vertex)) (and (=> (Isolated x) (not (exists ((y Vertex)) (or (Edge x y) (Edge y x))))) (=> (not (exists ((y Vertex)) (or (Edge x y) (Edge y x)))) (Isolated x)))))

; 5. Show that vertex E is reachable from vertex A and
; that no vertex in the graph is isolated.

(check-sat)
;(get-model)

; 1. Fully specify the graph by providing the definition of the Edge relation
(echo "A -> B")
(get-value ((Edge A B)(Edge B A)))
(echo "")

(echo "A -> C")
(get-value ((Edge A C)(Edge C A)))
(echo "")

(echo "A -> A")
(get-value ((Reachable A A)))
(echo "")

; 5. Show that vertex E is reachable from vertex A 

(echo "5.")
(echo "E is reachable from A")
(get-value ((Reachable A E)))
(echo "") 


; 5. and that no vertex in the graph is isolated.

(echo "5.")
(echo "_ is not isolated")
(get-value ((Isolated A)))
(echo "")(get-value ((Isolated B)))
(echo "")(get-value ((Isolated C)))
(echo "")(get-value ((Isolated D)))
(echo "")(get-value ((Isolated E)))
(echo "")(get-value ((Isolated F)))
(echo "")(get-value ((Isolated G)))
(echo "")(get-value ((Isolated H)))

;(echo "TEST")
;(get-value ((Edge A G))) sat when it should be not sat, as the axioms are not strong enough to prove the absence of a property
;(echo "TEST")

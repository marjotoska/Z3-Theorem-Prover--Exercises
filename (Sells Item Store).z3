	(set-option :produce-models true)

	; Datatypes (items, stores)
	(declare-datatypes () ((Item screwdriver saw hammer chips sweets cookie water juice coke)))
	(declare-datatypes () ((Store store1 store2 store3 store4)))

	; Predicates indicating whether an item is a tool, snack or beverage
	(declare-fun Tool (Item) Bool)
	(declare-fun Snack (Item) Bool)
	(declare-fun Beverage (Item) Bool)

	; Predicate indicating whether a store sells an item
	(declare-fun Sells (Item Store) Bool)

	; Define which items are tools, snacks, beverages
	(assert (forall ((x Item)) (= (Tool x) (or (= x screwdriver) (= x saw) (= x hammer)))))
	(assert (forall ((x Item)) (= (Snack x) (or (= x chips) (= x sweets) (= x cookie)))))
	(assert (forall ((x Item)) (= (Beverage x) (or (= x water) (= x juice) (= x coke)))))



	;; constraint 1
	;1. Any item is either a tool, a snack, or a beverage.

	(assert (forall ((x Item))  (or (= (Tool x) (not(Snack x)) (not (Beverage x))) 
													(= (Snack x) (not (Tool x)) (not (Beverage x))) 
													(= (Beverage x) (not (Tool x)) (not (Snack x))))))
													

	;; constraint 2
	;2. Store 1 and 4 sell saws and Store 3 sells sweets.

	(assert (and (Sells saw store1) (Sells saw store4) (Sells sweets store3)))

	;; constraint 3
	;3. Every item is sold by at least one store.

	(assert (forall ((x Item)) (exists ((y Store)) (Sells x y))))

	;; constraint 4
	;4. Exactly one store has all 3 types of snacks.
	
	(assert (exists ((x Store) (y Item) (z Item) (w Item)) (and (Snack y) (Snack z) (Snack w) (distinct y z w) (Sells y x) (Sells z x) (Sells w x))))

	;; constraint 5
	;5. There is no store that sells both water and saws.
	
	;(assert (forall ((x Store)) (not (and (Sells water x) (Sells saw x))))) ;doesn't sell both water and saws
	(assert (forall ((x Store)) (or (and (not (Sells water x)) (not (Sells saw x))) (not (and (Sells water x) (Sells saw x)))))) ;doesn't sell both water and saws OR doesn't sell water nor saws
	
	;; constraint 6
	;6. Any store that sells juice also sells another beverage.
	
	(assert (forall ((x Store)) (exists ((y Item)) (and (Beverage y) (distinct y juice) (Sells juice x) (Sells y x)))))
	
	
	;; constraint 7
	;7. Store 1 sells (at least) one tool, one snack and one beverage.
	
	(assert (exists ((x Item) (y Item) (z Item)) (and (Tool x) (Snack y) (Beverage z) (Sells x store1) (Sells y store1) (Sells z store1))))
	
	;; constraint 8
	;8. Store 2 has no beverages to offer.
	

	;(assert (exists ((x Item) (y Item) (z Item)) (not (and (Beverage x) (Beverage y) (Beverage z) (distinct x y z) (Sells x store2) (Sells y store2) (Sells z store2)))))

	(assert 
		(exists ((x Item) (y Item) (z Item) (j Item) (k Item) (l Item)) 
			(and  
				(Beverage x) (Beverage y) (Beverage z)
				(distinct x y z)
				(or
					(and (Tool j) (not (Snack j)) (not (Beverage j)))
					(and (Snack j) (not (Tool j)) (not (Beverage j)))
					(and (Tool k) (not (Snack k)) (not (Beverage k)))
					(and (Snack k) (not (Tool k)) (not (Beverage k)))
					(and (Tool l) (not (Snack l)) (not (Beverage l)))
					(and (Snack l) (not (Tool l)) (not (Beverage l)))	
				)
				(distinct j k l)
				(Sells j store2) (Sells k store2) (Sells l store2)
				(not (and (Sells x store2) (Sells y store2) (Sells z store2)))
			)
		)
	)
	;; constraint 9
	;9. Every store sells exactly 3 different items.
	
	(assert (forall ((x Store)) (exists ((y Item) (z Item) (w Item)) (and (distinct y z w) (Sells y x) (Sells z x) (Sells w x)))))

	;; constraint 10
	;10. Exactly 3 items are sold by 2 or more (possibly different) stores and they are one
    ;;tool and two snacks. All others items are sold by a single store.
	
	(assert (forall ((t Item)) (exists ((x Store) (y Store) (s Store) (z Item) (v Item) (w Item))  (and (distinct t z v w) (Tool z) (Snack v) (Snack w) (Sells z x) (Sells z y) (Sells v x) (Sells v y) (Sells w x) (Sells w y) (Sells t s) ))))


	(check-sat) ; need to be satisfiable here
	;(get-model)
	
	
	(echo "2. Store 1 and 4 sell saws and Store 3 sells sweets.")(get-value ((Sells saw store1)(Sells saw store4)(Sells sweets store3)))(echo "")

	
	(echo "5. There is no store that sells both water and saws.")(get-value ((Sells water store1)(Sells saw store1)))(echo "")
	(echo "5. There is no store that sells both water and saws.")(get-value ((Sells water store2)(Sells saw store2)))(echo "")	
	(echo "5. There is no store that sells both water and saws.")(get-value ((Sells water store3)(Sells saw store3)))(echo "")
	(echo "5. There is no store that sells both water and saws.")(get-value ((Sells water store4)(Sells saw store4)))(echo "")	
	
	
	(echo "(a) Store 1 sells coke")(get-value ((Sells coke store1)))(echo "")	
	
	(echo "(b) there is (at least) one snack sold by both Store 2 and 3")(get-value ((Sells chips store2)(Sells sweets store2)(Sells cookie store2)))(echo "")
	(echo "(b) there is (at least) one snack sold by both Store 2 and 3")(get-value ((Sells chips store3)(Sells sweets store3)(Sells cookie store3)))(echo "")
	
	
	(echo "(c) (at least) one store sells both juice and water")(get-value ((Sells juice store1)(Sells water store1)))(echo "")
	(echo "(c) (at least) one store sells both juice and water")(get-value ((Sells juice store2)(Sells water store2)))(echo "")
	(echo "(c) (at least) one store sells both juice and water")(get-value ((Sells juice store3)(Sells water store3)))(echo "")
	(echo "(c) (at least) one store sells both juice and water")(get-value ((Sells juice store4)(Sells water store4)))(echo "")
	
	;; statements (a-c) to prove
	
	;(a) Store 1 sells coke
	(assert (not (Sells coke store1)))
	
	;(b) there is (at least) one snack sold by both Store 2 and 3
	(assert (not (exists ((x Item)) (and (Snack x) (Sells x store2) (Sells x store3)))))
	
	;(c) (at least) one store sells both juice and water.
	(assert (not (exists ((x Store)) (and (Sells juice x) (Sells water x)))))
	(check-sat) ; need to be unsatisfiable here


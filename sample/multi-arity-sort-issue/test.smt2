(set-logic ALL_SUPPORTED)
(declare-sort I 1)
(declare-fun x () (I Bool))
(declare-fun y () (I Bool))
(assert (= x y))
(assert (not (= x y))) 
(check-sat)

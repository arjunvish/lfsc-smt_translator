(set-info :smt-lib-version 2.6)
(set-logic QF_AUFBV)
(set-info :source |These benchmarks are derived from a semi-automated proof of functional equivalence between two implementations of an Elliptic Curve Digital Signature Algorithm (ECDSA). More information about problem they encode can be found here: http://cps-vo.org/node/3405|)
(set-info :category "industrial")
(set-info :status sat)
(declare-fun x23 () (_ BitVec 1))
(declare-fun x22 () (_ BitVec 64))
(declare-fun x21 () (_ BitVec 832))
(declare-fun x20 ((_ BitVec 768) (_ BitVec 32) (_ BitVec 64)) (_ BitVec 832))
(declare-fun x19 () (_ BitVec 768))
(declare-fun x18 () (_ BitVec 64))
(declare-fun x17 () (_ BitVec 6))
(declare-fun x16 () (_ BitVec 64))
(declare-fun x15 () (_ BitVec 64))
(declare-fun x14 () (_ BitVec 64))
(declare-fun x13 () (_ BitVec 64))
(declare-fun x12 () (_ BitVec 32))
(declare-fun x10 () (_ BitVec 1))
(declare-fun x9 () (_ BitVec 1))
(declare-fun x7 () (_ BitVec 1))
(declare-fun x5 () (_ BitVec 1))
(declare-fun x4 () (_ BitVec 1))
(declare-fun x3 () (_ BitVec 1))
(declare-fun x2 () (Array (_ BitVec 5) (_ BitVec 32)))
(declare-fun x1 () (_ BitVec 32))
(declare-fun x0 () (_ BitVec 64))
(declare-fun p11 () Bool)
(declare-fun p8 () Bool)
(declare-fun p6 () Bool)
(assert (= x23 (ite (= x18 x22) (_ bv1 1) (_ bv0 1))))
(assert (= x22 ((_ extract 831 768) x21)))
(assert (= x21 (x20 x19 x1 x0)))
(assert (= x19 (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (concat (select x2 (_ bv23 5)) (select x2 (_ bv22 5))) (select x2 (_ bv21 5))) (select x2 (_ bv20 5))) (select x2 (_ bv19 5))) (select x2 (_ bv18 5))) (select x2 (_ bv17 5))) (select x2 (_ bv16 5))) (select x2 (_ bv15 5))) (select x2 (_ bv14 5))) (select x2 (_ bv13 5))) (select x2 (_ bv12 5))) (select x2 (_ bv11 5))) (select x2 (_ bv10 5))) (select x2 (_ bv9 5))) (select x2 (_ bv8 5))) (select x2 (_ bv7 5))) (select x2 (_ bv6 5))) (select x2 (_ bv5 5))) (select x2 (_ bv4 5))) (select x2 (_ bv3 5))) (select x2 (_ bv2 5))) (select x2 (_ bv1 5))) (select x2 (_ bv0 5)))))
(assert (= x18 (bvlshr x16 ((_ zero_extend 58) x17))))
(assert (= x17 (bvneg (_ bv32 6))))
(assert (= x16 (bvadd x0 x15)))
(assert (= x15 (bvshl x14 ((_ zero_extend 58) (_ bv1 6)))))
(assert (= x14 (bvand x13 (_ bv4294967295 64))))
(assert (= x13 ((_ sign_extend 32) x12)))
(assert (= x12 (select x2 ((_ extract 4 0) x1))))
(assert (= p11 (and p8 (bvsle x1 (_ bv23 32)))))
(assert (= x10 (bvand x7 x9)))
(assert (= x9 (ite (bvsle x1 (_ bv23 32)) (_ bv1 1) (_ bv0 1))))
(assert (= p8 (and (bvsle (_ bv0 32) x1) p6)))
(assert (= x7 (bvand x3 x5)))
(assert (= p6 (not (bvsle (_ bv24 32) x1))))
(assert (= x5 (bvnot x4)))
(assert (= x4 (ite (bvsle (_ bv24 32) x1) (_ bv1 1) (_ bv0 1))))
(assert (= x3 (ite (bvsle (_ bv0 32) x1) (_ bv1 1) (_ bv0 1))))
(assert true)
(assert (= (select x2 (_ bv31 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv30 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv29 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv28 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv27 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv26 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv25 5)) (_ bv0 32)))
(assert (= (select x2 (_ bv24 5)) (_ bv0 32)))
(assert (not (=> p11 (= x18 x22))))
(check-sat)
(exit)

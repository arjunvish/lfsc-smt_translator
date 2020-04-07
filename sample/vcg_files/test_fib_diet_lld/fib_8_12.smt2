; fib.8.5 (0x201440) - Equivalence of function: fib
(set-logic ALL_SUPPORTED)
(set-option :produce-models true)
(define-fun even_parity ((v (_ BitVec 8))) Bool (= (bvxor ((_ extract 0 0) v) ((_ extract 1 1) v) ((_ extract 2 2) v) ((_ extract 3 3) v) ((_ extract 4 4) v) ((_ extract 5 5) v) ((_ extract 6 6) v) ((_ extract 7 7) v)) #b0))
(define-fun mem_readbv8 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64))) (_ BitVec 8) (select m a))
(define-fun mem_readbv16 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64))) (_ BitVec 16) (concat (select m (bvadd a (_ bv1 64))) (select m a)))
(define-fun mem_readbv32 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64))) (_ BitVec 32) (concat (select m (bvadd a (_ bv3 64))) (concat (select m (bvadd a (_ bv2 64))) (concat (select m (bvadd a (_ bv1 64))) (select m a)))))
(define-fun mem_readbv64 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64))) (_ BitVec 64) (concat (select m (bvadd a (_ bv7 64))) (concat (select m (bvadd a (_ bv6 64))) (concat (select m (bvadd a (_ bv5 64))) (concat (select m (bvadd a (_ bv4 64))) (concat (select m (bvadd a (_ bv3 64))) (concat (select m (bvadd a (_ bv2 64))) (concat (select m (bvadd a (_ bv1 64))) (select m a)))))))))
(define-fun mem_writebv8 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64)) (v (_ BitVec 8))) (Array (_ BitVec 64) (_ BitVec 8)) (store m a ((_ extract 7 0) v)))
(define-fun mem_writebv16 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64)) (v (_ BitVec 16))) (Array (_ BitVec 64) (_ BitVec 8)) (store (store m a ((_ extract 7 0) v)) (bvadd a (_ bv1 64)) ((_ extract 15 8) v)))
(define-fun mem_writebv32 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64)) (v (_ BitVec 32))) (Array (_ BitVec 64) (_ BitVec 8)) (store (store (store (store m a ((_ extract 7 0) v)) (bvadd a (_ bv1 64)) ((_ extract 15 8) v)) (bvadd a (_ bv2 64)) ((_ extract 23 16) v)) (bvadd a (_ bv3 64)) ((_ extract 31 24) v)))
(define-fun mem_writebv64 ((m (Array (_ BitVec 64) (_ BitVec 8))) (a (_ BitVec 64)) (v (_ BitVec 64))) (Array (_ BitVec 64) (_ BitVec 8)) (store (store (store (store (store (store (store (store m a ((_ extract 7 0) v)) (bvadd a (_ bv1 64)) ((_ extract 15 8) v)) (bvadd a (_ bv2 64)) ((_ extract 23 16) v)) (bvadd a (_ bv3 64)) ((_ extract 31 24) v)) (bvadd a (_ bv4 64)) ((_ extract 39 32) v)) (bvadd a (_ bv5 64)) ((_ extract 47 40) v)) (bvadd a (_ bv6 64)) ((_ extract 55 48) v)) (bvadd a (_ bv7 64)) ((_ extract 63 56) v)))
(declare-fun fnstart_rcx () (_ BitVec 64))
(declare-fun fnstart_rdx () (_ BitVec 64))
(declare-fun fnstart_rbx () (_ BitVec 64))
(declare-fun fnstart_rsp () (_ BitVec 64))
(declare-fun fnstart_rbp () (_ BitVec 64))
(declare-fun fnstart_rsi () (_ BitVec 64))
(declare-fun fnstart_rdi () (_ BitVec 64))
(declare-fun fnstart_r8 () (_ BitVec 64))
(declare-fun fnstart_r9 () (_ BitVec 64))
(declare-fun fnstart_r12 () (_ BitVec 64))
(declare-fun fnstart_r13 () (_ BitVec 64))
(declare-fun fnstart_r14 () (_ BitVec 64))
(declare-fun fnstart_r15 () (_ BitVec 64))
(declare-const stack_alloc_min (_ BitVec 64))
(assert (= (bvand stack_alloc_min #x0000000000000fff) (_ bv0 64)))
(assert (bvult (_ bv4096 64) stack_alloc_min))
(define-fun stack_guard_min () (_ BitVec 64) (bvsub stack_alloc_min (_ bv4096 64)))
(assert (bvult stack_guard_min stack_alloc_min))
(declare-const stack_max (_ BitVec 64))
(assert (= (bvand stack_max #x0000000000000fff) (_ bv0 64)))
(assert (bvult stack_alloc_min stack_max))
(assert (bvule stack_alloc_min fnstart_rsp))
(assert (bvule fnstart_rsp (bvsub stack_max (_ bv8 64))))
(define-fun on_stack ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule stack_guard_min a) (bvule a e) (bvule e stack_max))))
(define-fun not_in_stack_range ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule a e) (or (bvule e stack_alloc_min) (bvule stack_max a)))))
(assert (bvult fnstart_rsp (bvsub stack_max (_ bv8 64))))
(assert (= ((_ extract 3 0) fnstart_rsp) (_ bv8 4)))
(define-fun alloca_2_mc_base () (_ BitVec 64) (bvsub fnstart_rsp (_ bv16 64)))
(define-fun alloca_2_mc_end () (_ BitVec 64) (bvsub fnstart_rsp (_ bv8 64)))
(define-fun mcaddr_in_alloca_2 ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule alloca_2_mc_base a) (bvule a e) (bvule e alloca_2_mc_end))))
(define-fun alloca_3_mc_base () (_ BitVec 64) (bvsub fnstart_rsp (_ bv24 64)))
(define-fun alloca_3_mc_end () (_ BitVec 64) (bvsub fnstart_rsp (_ bv16 64)))
(define-fun mcaddr_in_alloca_3 ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule alloca_3_mc_base a) (bvule a e) (bvule e alloca_3_mc_end))))
(define-fun mc_only_stack_range ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (on_stack a sz) (or (bvule e alloca_2_mc_base) (bvule alloca_2_mc_end a)) (or (bvule e alloca_3_mc_base) (bvule alloca_3_mc_end a)))))
(define-fun a201424_rip () (_ BitVec 64) #x0000000000201424)
(declare-fun a201424_rax () (_ BitVec 64))
(declare-fun a201424_rcx () (_ BitVec 64))
(declare-fun a201424_rdx () (_ BitVec 64))
(declare-fun a201424_rbx () (_ BitVec 64))
(declare-fun a201424_rsp () (_ BitVec 64))
(declare-fun a201424_rbp () (_ BitVec 64))
(declare-fun a201424_rsi () (_ BitVec 64))
(declare-fun a201424_rdi () (_ BitVec 64))
(declare-fun a201424_r8 () (_ BitVec 64))
(declare-fun a201424_r9 () (_ BitVec 64))
(declare-fun a201424_r10 () (_ BitVec 64))
(declare-fun a201424_r11 () (_ BitVec 64))
(declare-fun a201424_r12 () (_ BitVec 64))
(declare-fun a201424_r13 () (_ BitVec 64))
(declare-fun a201424_r14 () (_ BitVec 64))
(declare-fun a201424_r15 () (_ BitVec 64))
(declare-fun a201424_cf () Bool)
(declare-fun a201424_pf () Bool)
(declare-fun a201424_af () Bool)
(declare-fun a201424_zf () Bool)
(declare-fun a201424_sf () Bool)
(declare-fun a201424_tf () Bool)
(declare-fun a201424_if () Bool)
(define-fun a201424_df () Bool false)
(declare-fun a201424_of () Bool)
(declare-fun a201424_ie () Bool)
(declare-fun a201424_de () Bool)
(declare-fun a201424_ze () Bool)
(declare-fun a201424_oe () Bool)
(declare-fun a201424_ue () Bool)
(declare-fun a201424_pe () Bool)
(declare-fun a201424_ef () Bool)
(declare-fun a201424_es () Bool)
(declare-fun a201424_c0 () Bool)
(declare-fun a201424_c1 () Bool)
(declare-fun a201424_c2 () Bool)
(declare-fun a201424_RESERVED_STATUS_11 () Bool)
(declare-fun a201424_RESERVED_STATUS_12 () Bool)
(declare-fun a201424_RESERVED_STATUS_13 () Bool)
(declare-fun a201424_c3 () Bool)
(declare-fun a201424_RESERVED_STATUS_15 () Bool)
(define-fun a201424_x87top () (_ BitVec 3) (_ bv7 3))
(declare-fun a201424_tag0 () (_ BitVec 2))
(declare-fun a201424_tag1 () (_ BitVec 2))
(declare-fun a201424_tag2 () (_ BitVec 2))
(declare-fun a201424_tag3 () (_ BitVec 2))
(declare-fun a201424_tag4 () (_ BitVec 2))
(declare-fun a201424_tag5 () (_ BitVec 2))
(declare-fun a201424_tag6 () (_ BitVec 2))
(declare-fun a201424_tag7 () (_ BitVec 2))
(declare-fun a201424_mm0 () (_ BitVec 80))
(declare-fun a201424_mm1 () (_ BitVec 80))
(declare-fun a201424_mm2 () (_ BitVec 80))
(declare-fun a201424_mm3 () (_ BitVec 80))
(declare-fun a201424_mm4 () (_ BitVec 80))
(declare-fun a201424_mm5 () (_ BitVec 80))
(declare-fun a201424_mm6 () (_ BitVec 80))
(declare-fun a201424_mm7 () (_ BitVec 80))
(declare-fun a201424_zmm0 () (_ BitVec 512))
(declare-fun a201424_zmm1 () (_ BitVec 512))
(declare-fun a201424_zmm2 () (_ BitVec 512))
(declare-fun a201424_zmm3 () (_ BitVec 512))
(declare-fun a201424_zmm4 () (_ BitVec 512))
(declare-fun a201424_zmm5 () (_ BitVec 512))
(declare-fun a201424_zmm6 () (_ BitVec 512))
(declare-fun a201424_zmm7 () (_ BitVec 512))
(declare-fun a201424_zmm8 () (_ BitVec 512))
(declare-fun a201424_zmm9 () (_ BitVec 512))
(declare-fun a201424_zmm10 () (_ BitVec 512))
(declare-fun a201424_zmm11 () (_ BitVec 512))
(declare-fun a201424_zmm12 () (_ BitVec 512))
(declare-fun a201424_zmm13 () (_ BitVec 512))
(declare-fun a201424_zmm14 () (_ BitVec 512))
(declare-fun a201424_zmm15 () (_ BitVec 512))
(declare-fun a201424_zmm16 () (_ BitVec 512))
(declare-fun a201424_zmm17 () (_ BitVec 512))
(declare-fun a201424_zmm18 () (_ BitVec 512))
(declare-fun a201424_zmm19 () (_ BitVec 512))
(declare-fun a201424_zmm20 () (_ BitVec 512))
(declare-fun a201424_zmm21 () (_ BitVec 512))
(declare-fun a201424_zmm22 () (_ BitVec 512))
(declare-fun a201424_zmm23 () (_ BitVec 512))
(declare-fun a201424_zmm24 () (_ BitVec 512))
(declare-fun a201424_zmm25 () (_ BitVec 512))
(declare-fun a201424_zmm26 () (_ BitVec 512))
(declare-fun a201424_zmm27 () (_ BitVec 512))
(declare-fun a201424_zmm28 () (_ BitVec 512))
(declare-fun a201424_zmm29 () (_ BitVec 512))
(declare-fun a201424_zmm30 () (_ BitVec 512))
(declare-fun a201424_zmm31 () (_ BitVec 512))
(declare-const alloca_2_llvm_base (_ BitVec 64))
(define-fun alloca_2_llvm_end () (_ BitVec 64) (bvadd alloca_2_llvm_base (_ bv8 64)))
(assert (bvule alloca_2_llvm_base alloca_2_llvm_end))
(define-fun llvmaddr_in_alloca_2 ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule alloca_2_llvm_base a) (bvule a e) (bvule e alloca_2_llvm_end))))
(define-fun llvm_2 () (_ BitVec 64) alloca_2_llvm_base)
(declare-const alloca_3_llvm_base (_ BitVec 64))
(define-fun alloca_3_llvm_end () (_ BitVec 64) (bvadd alloca_3_llvm_base (_ bv8 64)))
(assert (bvule alloca_3_llvm_base alloca_3_llvm_end))
(define-fun llvmaddr_in_alloca_3 ((a (_ BitVec 64)) (sz (_ BitVec 64))) Bool (let ((e (bvadd a sz))) (and (bvule alloca_3_llvm_base a) (bvule a e) (bvule e alloca_3_llvm_end))))
(assert (or (bvule alloca_3_llvm_end alloca_2_llvm_base) (bvule alloca_2_llvm_end alloca_3_llvm_base)))
(define-fun llvm_3 () (_ BitVec 64) alloca_3_llvm_base)
(declare-const x86mem_0 (Array (_ BitVec 64) (_ BitVec 8)))
(define-fun return_addr () (_ BitVec 64) (mem_readbv64 x86mem_0 fnstart_rsp))
(define-fun llvm_0 () (_ BitVec 64) fnstart_rdi)
(assert (= a201424_rbp (bvsub fnstart_rsp (_ bv8 64))))
(assert (= a201424_rsp (bvsub fnstart_rsp (_ bv40 64))))
(assert (= (mem_readbv64 x86mem_0 (bvsub fnstart_rsp (_ bv8 64))) fnstart_rbp))
(assert (= a201424_rbx fnstart_rbx))
(assert (= a201424_r12 fnstart_r12))
(assert (= a201424_r13 fnstart_r13))
(assert (= a201424_r14 fnstart_r14))
(assert (= a201424_r15 fnstart_r15))
; LLVM: %9 = load i64, i64* %3, align 8
(define-fun x86local_0 () (_ BitVec 64) (bvadd a201424_rbp (_ bv18446744073709551600 64)))
(assert (llvmaddr_in_alloca_3 llvm_3 (_ bv8 64)))
(assert (mcaddr_in_alloca_3 x86local_0 (_ bv8 64)))
(assert (= (bvsub llvm_3 alloca_3_llvm_base) (bvsub x86local_0 alloca_3_mc_base)))
(define-fun x86local_1 () (_ BitVec 64) (mem_readbv64 x86mem_0 x86local_0))
(define-fun llvm_9 () (_ BitVec 64) x86local_1)
; LLVM: %10 = sub i64 %9, 1
(define-fun llvm_10 () (_ BitVec 64) (bvsub llvm_9 (_ bv1 64)))
; LLVM: %11 = call i64 (i64) @fib(i64 %10)
(define-fun x86local_2 () Bool (distinct ((_ extract 64 64) (bvsub (bvsub ((_ sign_extend 1) x86local_1) (bvneg ((_ sign_extend 1) (_ bv1 64)))) (ite false (_ bv1 65) (_ bv0 65)))) ((_ extract 63 63) (bvsub (bvsub ((_ sign_extend 1) x86local_1) (bvneg ((_ sign_extend 1) (_ bv1 64)))) (ite false (_ bv1 65) (_ bv0 65))))))
(define-fun x86local_3 () (_ BitVec 4) ((_ extract 3 0) x86local_1))
(define-fun x86local_4 () Bool (bvult x86local_3 (_ bv1 4)))
(define-fun x86local_5 () Bool (bvult x86local_1 (_ bv1 64)))
(define-fun x86local_6 () (_ BitVec 64) (bvsub x86local_1 (_ bv1 64)))
(define-fun x86local_7 () Bool (bvslt x86local_6 (_ bv0 64)))
(define-fun x86local_8 () Bool (= x86local_6 (_ bv0 64)))
(define-fun x86local_9 () (_ BitVec 8) ((_ extract 7 0) x86local_6))
(define-fun x86local_10 () Bool (even_parity x86local_9))
(define-fun x86local_11 () (_ BitVec 64) (bvsub a201424_rsp (_ bv8 64)))
(assert (mc_only_stack_range x86local_11 (_ bv8 64)))
(define-fun x86mem_1 () (Array (_ BitVec 64) (_ BitVec 8)) (mem_writebv64 x86mem_0 x86local_11 #x0000000000201434))
(assert (= #x0000000000201400 #x0000000000201400))
(assert (= llvm_10 x86local_6))
(assert (= (mem_readbv64 x86mem_1 x86local_11) #x0000000000201434))
(define-fun a201434_rip () (_ BitVec 64) #x0000000000201434)
(declare-fun a201434_rax () (_ BitVec 64))
(declare-fun a201434_rcx () (_ BitVec 64))
(declare-fun a201434_rdx () (_ BitVec 64))
(define-fun a201434_rbx () (_ BitVec 64) a201424_rbx)
(define-fun a201434_rsp () (_ BitVec 64) (bvadd x86local_11 (_ bv8 64)))
(define-fun a201434_rbp () (_ BitVec 64) a201424_rbp)
(declare-fun a201434_rsi () (_ BitVec 64))
(declare-fun a201434_rdi () (_ BitVec 64))
(declare-fun a201434_r8 () (_ BitVec 64))
(declare-fun a201434_r9 () (_ BitVec 64))
(declare-fun a201434_r10 () (_ BitVec 64))
(declare-fun a201434_r11 () (_ BitVec 64))
(define-fun a201434_r12 () (_ BitVec 64) a201424_r12)
(define-fun a201434_r13 () (_ BitVec 64) a201424_r13)
(define-fun a201434_r14 () (_ BitVec 64) a201424_r14)
(define-fun a201434_r15 () (_ BitVec 64) a201424_r15)
(declare-fun a201434_cf () Bool)
(declare-fun a201434_pf () Bool)
(declare-fun a201434_af () Bool)
(declare-fun a201434_zf () Bool)
(declare-fun a201434_sf () Bool)
(declare-fun a201434_tf () Bool)
(declare-fun a201434_if () Bool)
(define-fun a201434_df () Bool false)
(declare-fun a201434_of () Bool)
(declare-fun a201434_ie () Bool)
(declare-fun a201434_de () Bool)
(declare-fun a201434_ze () Bool)
(declare-fun a201434_oe () Bool)
(declare-fun a201434_ue () Bool)
(declare-fun a201434_pe () Bool)
(declare-fun a201434_ef () Bool)
(declare-fun a201434_es () Bool)
(declare-fun a201434_c0 () Bool)
(declare-fun a201434_c1 () Bool)
(declare-fun a201434_c2 () Bool)
(declare-fun a201434_RESERVED_STATUS_11 () Bool)
(declare-fun a201434_RESERVED_STATUS_12 () Bool)
(declare-fun a201434_RESERVED_STATUS_13 () Bool)
(declare-fun a201434_c3 () Bool)
(declare-fun a201434_RESERVED_STATUS_15 () Bool)
(define-fun a201434_x87top () (_ BitVec 3) (_ bv7 3))
(declare-fun a201434_tag0 () (_ BitVec 2))
(declare-fun a201434_tag1 () (_ BitVec 2))
(declare-fun a201434_tag2 () (_ BitVec 2))
(declare-fun a201434_tag3 () (_ BitVec 2))
(declare-fun a201434_tag4 () (_ BitVec 2))
(declare-fun a201434_tag5 () (_ BitVec 2))
(declare-fun a201434_tag6 () (_ BitVec 2))
(declare-fun a201434_tag7 () (_ BitVec 2))
(declare-fun a201434_mm0 () (_ BitVec 80))
(declare-fun a201434_mm1 () (_ BitVec 80))
(declare-fun a201434_mm2 () (_ BitVec 80))
(declare-fun a201434_mm3 () (_ BitVec 80))
(declare-fun a201434_mm4 () (_ BitVec 80))
(declare-fun a201434_mm5 () (_ BitVec 80))
(declare-fun a201434_mm6 () (_ BitVec 80))
(declare-fun a201434_mm7 () (_ BitVec 80))
(declare-fun a201434_zmm0 () (_ BitVec 512))
(declare-fun a201434_zmm1 () (_ BitVec 512))
(declare-fun a201434_zmm2 () (_ BitVec 512))
(declare-fun a201434_zmm3 () (_ BitVec 512))
(declare-fun a201434_zmm4 () (_ BitVec 512))
(declare-fun a201434_zmm5 () (_ BitVec 512))
(declare-fun a201434_zmm6 () (_ BitVec 512))
(declare-fun a201434_zmm7 () (_ BitVec 512))
(declare-fun a201434_zmm8 () (_ BitVec 512))
(declare-fun a201434_zmm9 () (_ BitVec 512))
(declare-fun a201434_zmm10 () (_ BitVec 512))
(declare-fun a201434_zmm11 () (_ BitVec 512))
(declare-fun a201434_zmm12 () (_ BitVec 512))
(declare-fun a201434_zmm13 () (_ BitVec 512))
(declare-fun a201434_zmm14 () (_ BitVec 512))
(declare-fun a201434_zmm15 () (_ BitVec 512))
(declare-fun a201434_zmm16 () (_ BitVec 512))
(declare-fun a201434_zmm17 () (_ BitVec 512))
(declare-fun a201434_zmm18 () (_ BitVec 512))
(declare-fun a201434_zmm19 () (_ BitVec 512))
(declare-fun a201434_zmm20 () (_ BitVec 512))
(declare-fun a201434_zmm21 () (_ BitVec 512))
(declare-fun a201434_zmm22 () (_ BitVec 512))
(declare-fun a201434_zmm23 () (_ BitVec 512))
(declare-fun a201434_zmm24 () (_ BitVec 512))
(declare-fun a201434_zmm25 () (_ BitVec 512))
(declare-fun a201434_zmm26 () (_ BitVec 512))
(declare-fun a201434_zmm27 () (_ BitVec 512))
(declare-fun a201434_zmm28 () (_ BitVec 512))
(declare-fun a201434_zmm29 () (_ BitVec 512))
(declare-fun a201434_zmm30 () (_ BitVec 512))
(declare-fun a201434_zmm31 () (_ BitVec 512))
(declare-const x86mem_2 (Array (_ BitVec 64) (_ BitVec 8)))
(assert (eqrange x86mem_2 x86mem_1 (bvadd x86local_11 (_ bv8 64)) (bvadd fnstart_rsp (_ bv7 64))))
(define-fun llvm_11 () (_ BitVec 64) a201434_rax)
; LLVM: %12 = load i64, i64* %3, align 8
(define-fun x86local_12 () (_ BitVec 64) (bvadd a201434_rbp (_ bv18446744073709551600 64)))
(assert (llvmaddr_in_alloca_3 llvm_3 (_ bv8 64)))
(assert (mcaddr_in_alloca_3 x86local_12 (_ bv8 64)))
(assert (= (bvsub llvm_3 alloca_3_llvm_base) (bvsub x86local_12 alloca_3_mc_base)))
(define-fun x86local_13 () (_ BitVec 64) (mem_readbv64 x86mem_2 x86local_12))
(define-fun llvm_12 () (_ BitVec 64) x86local_13)
; LLVM: %13 = sub i64 %12, 2
(define-fun llvm_13 () (_ BitVec 64) (bvsub llvm_12 (_ bv2 64)))
; LLVM: %14 = call i64 (i64) @fib(i64 %13)
(define-fun x86local_14 () Bool (distinct ((_ extract 64 64) (bvsub (bvsub ((_ sign_extend 1) x86local_13) (bvneg ((_ sign_extend 1) (_ bv2 64)))) (ite false (_ bv1 65) (_ bv0 65)))) ((_ extract 63 63) (bvsub (bvsub ((_ sign_extend 1) x86local_13) (bvneg ((_ sign_extend 1) (_ bv2 64)))) (ite false (_ bv1 65) (_ bv0 65))))))
(define-fun x86local_15 () (_ BitVec 4) ((_ extract 3 0) x86local_13))
(define-fun x86local_16 () Bool (bvult x86local_15 (_ bv2 4)))
(define-fun x86local_17 () Bool (bvult x86local_13 (_ bv2 64)))
(define-fun x86local_18 () (_ BitVec 64) (bvsub x86local_13 (_ bv2 64)))
(define-fun x86local_19 () Bool (bvslt x86local_18 (_ bv0 64)))
(define-fun x86local_20 () Bool (= x86local_18 (_ bv0 64)))
(define-fun x86local_21 () (_ BitVec 8) ((_ extract 7 0) x86local_18))
(define-fun x86local_22 () Bool (even_parity x86local_21))
(define-fun x86local_23 () (_ BitVec 64) (bvadd a201434_rbp (_ bv18446744073709551592 64)))
(assert (mc_only_stack_range x86local_23 (_ bv8 64)))
(define-fun x86mem_3 () (Array (_ BitVec 64) (_ BitVec 8)) (mem_writebv64 x86mem_2 x86local_23 a201434_rax))
(define-fun x86local_24 () (_ BitVec 64) (bvsub a201434_rsp (_ bv8 64)))
(assert (mc_only_stack_range x86local_24 (_ bv8 64)))
(define-fun x86mem_4 () (Array (_ BitVec 64) (_ BitVec 8)) (mem_writebv64 x86mem_3 x86local_24 #x0000000000201445))
(check-sat-assuming ((distinct #x0000000000201400 #x0000000000201400)))
(exit)

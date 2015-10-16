;;; Continuation Passing Style
;;; = CPS

;;; Properties of CPS
;;; - rewriting code, such that:
;;; - no anonymous temporary value (all temps are named)
;;;   You can't write: a+b*c aka (+ a (* b c))
;;;   because b*c needs a name.
;;; - only tail-recursive procedure calls are allowed
;;; - never return a value (can only call continuation on it)
;;; - turns code inside-out and makes it all confusing

;;; Add extra parameter to all procedures, called the "continuation"

(define c+ (λ (c x y) (c (+ x y))))
(define c* (λ (c x y) (c (* x y))))
(define c- (λ (c x y) (c (- x y))))
(define c= (λ (ct cf x y) ((if (= x y) ct cf))))

;;; Non-TR-definition of factorial
(define fact
  (λ (n)
    (if (= n 0)
	1
	(* n (fact (- n 1))))))

;;; TR-definition of factorial
(define fact-tr
  (λ (n)
    (fact-aux 1 n)))

(define fact-aux
  (λ (a n)
    (if (= n 0)
	a
	(fact-aux (* a n) (- n 1)))))

;;; Convert to CPS

(define cfact
  (λ (c n)
			       (c* c n fnm1))
			nm1))
	      n 1))
    (c= (λ () (c 1))
	(λ () (c- (λ (nm1) ;; nm1 = n-1
		    (cfact (λ (fnm1) ;; fnm1 = (n-1)!
	n 0)))

(define cfact-tr
  (λ (c n)
    (cfact-aux c 1 n)))

(define cfact-aux
  (λ:cfact_aux (c a n) ; return address
    (c= (λ:L1 () (c a))
        (λ:L2 ()
	  (c* (λ:L3 (atn)
		(c- (λ:L4 (nm1)
		      (cfact-aux C atn nm1)) n 1))
	      a n))
        1 n)))

;;cfact_aux:
;;	push 1
;;	push n
;;	= L2
;;
;;L1: push a
;;	ret
;;L2:	push a
;;	push n
;;	TIMES
;;	...
;;	SUBTRACT
;;	...


;; > (cfact (λ (r) (list r r r)) 3)
;; (6 6 6)

(define id (λ (x) x)) ; identity function

;; > (cfact id 100)
;; 933262154...

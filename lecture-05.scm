;;; Scheme

;;; Tail Recursion
;;; Bad terminology, but hey that's the English language.
;;; http://www.explainxkcd.com/wiki/index.php/1270:_Functional
;;; Functional programming combines the flexibility and power of abstract mathematics
;;; with the intuitive clarity of abstract mathematics.

;;; Sussman and Steele, "Lambda the Ultimate X", (the "lambda papers")
;;; http://lambda-the-ultimate.org/papers

;; Source Language:
;;	foo(x,y,z)
;;	...

;; Assembly Language:
;;	push z # marshal the arguments
;;	push y
;;	push x
;;	push L17
;;	jump foo
;; L17:	...

;; foo: ...
;;	jump address-on-top-of-stack-and-pop-it

;; Source:
;;	return foo(x,y,z)    // This is a "tail recursive call"

;; Assembly Language:
;;	push z # marshal the arguments
;;	push y
;;	push x
;;	push L17
;;	jump foo
;; L17:	jump address-on-top-of-stack-and-pop-it
;;; Like forwarding a letter from me to you, back to me, then to 'Joe'.

;;; Three things are needed for the procedure call
;;; 1. marshal the arguments
;;; 2. branch to return
;;; 3. push return address

;; Assembly Language OPTIMIZED WITH TAIL RECURSION
;;	push z # marshal the arguments
;;	push y
;;	push x
;;	jump foo
;;; Cut out the waste and just forward the letter straight to 'Joe'.

;; Use this trick to mechanically transform code gotos into procedure calls

;; // add up sqrt of all prime numbers between n1 and n2

;;; Fortran code - the horror
;; double ssp(int n1, int n2) {
;;	int t = 0;
;;	i = n1;
;; top:	if (i>n2) {
;;	  goto bot;
;;	} else {
;;	  if (prime(i)) {
;;	    t = t+sqrt(i);
;;	    i = i+1;
;;	    goto top;
;;	  } else {
;;	    i = i+1;
;;	    goto top;
;;	  }
;;	}
;; bot:	return t;
;; }
;;; The hated goto, considered harmful
;;; See https://en.wikipedia.org/wiki/Fortran#Humor

;;; Translation of the above Fortran code
(define ssp (λ (n1 n2) (ssp-top n1 n2 0 n1)))
(define ssp-top
  (λ (n1 n2 t i)
    (if (> i n2)
	(ssp-bot t)
	(if (prime? i)
	    (ssp-top n1 n2 (+ t (sqrt i)) (+ i 1))
	    (ssp-top n1 n2 t (+ i 1))))))
(define ssp-bot (λ (t) t))

;;; GPU's are horrible

;;; Adding labels is like adding a programming/break point
;;; we can stop at any point and look at our live variables
;; double ssp(int n1, int n2) {
;;	int t = 0;
;; t1:	i = n1;
;; top:	if (i>n2) {
;; t1a:	  goto bot;
;;	} else {
;; t2:	  if (prime(i)) {
;; t3:	    t = t+sqrt(i);
;; t4:	    i = i+1;
;; t5:	    goto top;
;;	  } else {
;; t6:	    i = i+1;
;; t7:	    goto top;
;;	  }
;;	}
;; bot:	return t;
;; }

(define ttp (λ (n1 n2) (t1 n1 n2 0)))
(define t1 (λ (n1 n2 t) (top n1 n2 t n1)))
(define ttop (λ (n1 n2 t i) (if (> i n2) (t1a n1 n2 t i) (t2 n1 n2 t i))))
(define t1a (λ (n1 n2 t i) (tbot t)))
(define t2 (λ (n1 n2 t i) (if (prime? i) (t3 n1 n2 t i) (t6 n1 n2 t i))))
(define t3 (λ (n1 n2 t i) (t4 n1 n2 (+ t (sqrt i)) i)))
(define t4 (λ (n1 n2 t i) (t5 n1 n2 t (+ i 1))))
(define t5 (λ (n1 n2 t i) (ttop n1 n2 t i)))
(define t6 (λ (n1 n2 t i) (t7 n1 n2 t (+ i 1))))
(define t7 (λ (n1 n2 t i) (ttop n1 n2 t i)))
(define tbot (λ (t) t))
;;; Horrible to read but it happens inside the compiler (possibly even more horrible in reality)

;;; What's pretty cool about Tail Recursion - pretty clear loops

;;; sum_i={0,n} sqrt(i)
(define ssqrt1
  (λ (n)
    (if (zero? n)
	0
	(+ (sqrt n)
	   (ssqrt1 (- n 1))))))
;;; This will stack overflow in C/Java on large inputs
;;; Scheme tries to optimise for tail recursion so it doesn't blow the stack

;;; sum_i={0,n} sqrt(i)
(define ssqrt2
  (λ (n)
    (ssqrt2-loop 0 n)))

;;; t + sum_i={0,n} sqrt(i)
(define ssqrt2-loop
  (λ (t n)
    (if (zero? n)
	t
	(ssqrt2-loop (+ t (sqrt n)) (- n 1)))))

;; (define ssqrt2-loop
;;   (λ (t n)
;;     (if (NONTR:zero? n)
;; 	t
;; 	(TR:ssqrt2-loop (NONTR:+ t (NONTR:sqrt n)) (NONTR:- n 1)))))


;;; Lecture 3 - some simple language processing
;;;  - a simple interpreter
;;;  - a simple expression differentiator

;;; Scheme Syntax in BNF

;;; <scheme-program> ::= <e>*
;;; <e> ::= <const> | <variable> | <special-form> | <funcall>
;;; <const> ::= <boolean> | <number> | <string> | <character> | <vector> | ...
;;; <number> ::= <integer> | <float>
;;; <integer> ::= ['-'] <digit>+
;;; <float> ::= ['-'] <digit>* '.' <digit>+ [ 'e' ['-'] <digit>+ ]
;;;           | ['-'] <digit>+ '.' <digit>* [ 'e' ['-'] <digit>+ ]
;;; <variable> ::= ['a'|...|'z'|'0'|...|'9'|'+'|...]+     (restrictions, not reserved word)
;;; <special-form> ::= '(lambda (' <variable>* ')' <e> ')'
;;;                  | '(define' <variable> <e> ')'
;;;                  | '(quote' <SEXPR> ')'
;;; <funcall> ::= '(' <e> <e>* ')'

;;; Little Expression in BNF
;;; <le> ::= <number>
;;;        | '(+' <le> <le> ')'
;;;        | '(*' <le> <le> ')'

;;; examples of Little Expressions:
;;;   7
;;;   (+ 7 2)
;;;   (* (+ 7 9) (* 2 (+ 1 4)))
;;; (le-eval (quote 7))  =>  7
;;; (le-eval (quote (+ 7 2)))   =>   9
;;; (le-eval (quote (* (+ 7 9) (* 2 (+ 1 4)))))   =>   160

'(define le-eval
   (λ (le)
     (if (number? le)
	 le
	 (if (equal? (car le) (quote +))
	     (+ (le-eval (cadr le)) (le-eval (caddr le)))
	     (if (equal? (car le) (quote *))
		 (* (le-eval (cadr le)) (le-eval (caddr le)))
		 (error "bad little expression" le))))))

;;; translated when Scheme *reads* text:
;;; 'SOMETHING   =>   (quote SOMETHING)

;; > (quote foo)
;; foo
;; > foo
;; foo: undefined;
;;  cannot reference undefined identifier
;;   context...:
;;    /usr/share/racket/collects/racket/private/misc.rkt:87:7
;; > 'foo
;; foo
;; > (car (quote (x y)))
;; x
;; > (car '(x y))
;; x
;; > (car '(quote x))
;; quote
;; > (car ''x)
;; quote

;;; examples of Little Expressions:
;;;   7
;;;   (+ 7 2)
;;;   (* (+ 7 9) (* 2 (+ 1 4)))
;;; (le-eval '7)  =>  7
;;; (le-eval '(+ 7 2))   =>   9
;;; (le-eval '(* (+ 7 9) (* 2 (+ 1 4))))   =>   160

'(define le-eval
   (λ (le)
     (if (number? le)
	 le
	 (if (equal? (car le) '+)
	     (+ (le-eval (cadr le)) (le-eval (caddr le)))
	     (if (equal? (car le) '*)
		 (* (le-eval (cadr le)) (le-eval (caddr le)))
		 (error "bad little expression" le))))))

;;; Special form: cond, stands for list of conditionals
;; (cond (<test1> <e1>)
;;       (<test2> <e2>)
;;       (<test3> <e3>)
;;       (else <e4>))
;;; Is translated into nested if's:
;; (if <test1>
;;     <e1>
;;     (if <test2>
;; 	<e2>
;; 	(if <test3>
;; 	    <e3>
;; 	    <e4>)))
;;; This is a "Macro"

(define le-eval
  (λ (le)
    (cond ((number? le) le)
	  ((equal? (car le) '+)
	   (+ (le-eval (cadr le)) (le-eval (caddr le))))
	  ((equal? (car le) '*)
	   (* (le-eval (cadr le)) (le-eval (caddr le))))
	  (else (error "bad little expression" le)))))

;;; A "Less Little Expression" is a little expression, or the symbol x
;;; (which can be embedded)
;;; Examples of LLEs:
;;;  x
;;;  (+ x 1)
;;;  (+ (* x (+ 7 x)) (* (* (+ 1 x) (+ 3 x)) (* x x)))

;;; take the derivative (in the Newton / Leibnitz sense) of an LLE wrt x

'(define d/dx
   (λ (e)
     (cond ((number? e) 0)
	   ((equal? e 'x) 1)
	   ((equal? (car e) '+)
	    (list '+
		  (d/dx (cadr e))
		  (d/dx (caddr e))))
	   ((equal? (car e) '*)
	    ;; Leibnitz Rule: d/dx u*v = u * dv/dx + du/dx * v
	    (list '+
		  (list '*
			(cadr e)	 ; u
			(d/dx (caddr e))) ; dv/dx
		  (list '*
			(d/dx (cadr e))	; du/dx
			(caddr e))))	; v
	   (else (error "bad LLE" le)))))

;;; Deficiencies:
;;;  - returns overly-complex expressions
;;;  - code is ugly
;;;  - only takes derivative with respect to 'x'
'(define d/dx
   (λ (e)
     (cond ((number? e) 0)
	   ((equal? e 'x) 1)
	   (else
	    ((λ (u v)
	       (cond ((equal? (car e) '+)
		      (list '+
			    (d/dx u)
			    (d/dx v)))
		     ((equal? (car e) '*)
		      ;; Leibnitz Rule: d/dx u*v = u * dv/dx + du/dx * v
		      (list '+
			    (list '* u (d/dx v))
			    (list '* (d/dx u) v)))
		     (else (error "bad LLE" le))))
	     (cadr e) (caddr e))))))

;;; let

(define d/dx
   (λ (e)
     (cond ((number? e) 0)
	   ((equal? e 'x) 1)
	   (else
	    (let ((u (cadr e))
		  (v (caddr e)))
	      (cond ((equal? (car e) '+)
		     (list '+
			   (d/dx u)
			   (d/dx v)))
		    ((equal? (car e) '*)
		     ;; Leibnitz Rule: d/dx u*v = u * dv/dx + du/dx * v
		     (list '+
			   (list '* u (d/dx v))
			   (list '* (d/dx u) v)))
		    (else (error "bad LLE" le))))))))

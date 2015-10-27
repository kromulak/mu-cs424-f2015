;;; Migration of semantic constructs to "user level"
;;; - local variable binding (macro expand let into ((λ...)...))
;;; - conditionals like if (macro expand into clopsures & library function or lambda/λ-expressions)
;;; - goto, loops (tail-recursive procedure call)
;;; - non-tail-recursive procedure call (use continuations; convert to CPS)
;;; - data structures (implement as closures) [L09]
;;; - objects (closures) [L09]

(define count-nums
  (λ (s)
    (cond ((number? s) 1)
	  ((pair? s) (+ (count-nums (car s))
			(count-nums (cdr s))))
	  (else 0))))
			  
;;; could pass the following expression to my-eval ... but it will get an error.

'(let ((count-ns (λ (s)
		   (cond ((number? s) 1)
			 ((pair? s) (+ (count-ns (car s)) ;; outside the scope of the definition
				       (count-ns (cdr s))))
			 (else 0)))))
   (count-ns '(aye (((((bee (((3) dee))))) 8)))))
						  
;; > (let ((pi (+ pi 1))) pi)
;; 4.1415926...
;; > (let ((x (+ x 1))) x)
;; x: undefined;
;; cannot reference undefined identifier
;; context...:
;; /usr/share/racket/collects/racket/private/misc.rkt:87:7

;;; Is there some way to just use lambda to define a recursive function? Yes!

(let ((count-nums0 (λ (count-nums s)
		     (cond ((number? s) 1)
			   ((pair? s) (+ (count-nums00 count-nums00 (car s))
					 (count-nums00 count-nums00 (cdr s))))
			   (else 0)))))
  (let ((count-nums (λ (s) 
		      (count-nums0 count-nums0 s))))
    (count-nums '(aye (((((bee (((3) dee))))) 8))))))

;;; Curried Function
(define regular-plus (λ (x y) (+ x y)))
(define curreid-plus (λ (x) (λ (y) (+ x y)))) ; needs to be written as ((curried-plus x) y)

;;; All functions in Haskell are curried functions

(define curry (λ (ncbf) (λ (x) (λ (y) (ncbf x y))))) ; ncbf = non-curried-binary-function
(define uncurry (λ (cbf) (λ (x y) ((cbf x) y)))) ; cbf = curried-binary-function
		
;; > ((curry +) 1)
;; #<procedure:...4/lecture-10.scm:49:54>

;; > (((curry +) 1) 2)
;; 3

;; > ((uncurry (curry +)) 3 4)
;; 7

(let ((count-nums0 (λ (count-nums s)
		     (λ (s)
		       (cond ((number? s) 1)
			     ((pair? s) (+ (count-nums00 count-nums00 (car s))
					   (count-nums00 count-nums00 (cdr s))))
			     (else 0))))))
  (let ((count-nums (λ (s) 
		      ((count-nums0 count-nums0) s))))
    (count-nums '(aye (((((bee (((3) dee))))) 8))))))
		
;;; η-reduction ("eta reduction")

;; this: (λ (x) (e x))
;; is equivalent to this: e

;; eta-convert the above:

(let ((count-nums0 (λ (count-nums00)
		     (λ (s)
		       (cond ((number? s) 1)
			     ((pair? s) (+ ((count-nums00 count-nums00 (car s))
					    ((count-nums00 count-nums00 (cdr s))))
					   (else 0))))))))
  (let ((count-nums (count-nums0 count-nums0)))
    (count-nums '(aye (((((bee (((3) dee))))) 8))))))
		
;;; Try to simplify the above:

(let ((count-nums0 (λ (count-nums00)
		     (let ((f (count-nums00 count-nums00)))
		       (λ (s)
			 (cond ((number? s) 1)
			       ((pair? s) (+ (f (car s))
					     (f (cdr s))))
			       (else 0)))))))
  (let ((count-nums count-nums0))
    (count-nums '(aye (((((bee (((3) dee))))) 8))))))
		
;; g = (λ (f) (λ (s) (... code that tries to recurse by calling f ...)))
;; We want to convert g into a recursive function.
;; Let's call (Y g) that recursive function.
;; We want the following property: (g (Y g)) = (Y g)
;; In maths, when f(c) = c we say that c is a fixedpoint of f.
;; We want to find a fixedpoint of g.
;; We want (Y g) to be a fixedpoint of g.

;; (define Y (λ (g) (g (Y g)))) ; won't work because...
;; (define Y (λ (g) (g (g (g (Y g)))))) ; ick...

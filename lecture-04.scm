;;; Deficiencies:
;;;  - returns overly-complex expressions
;;;  - code is ugly
;;;  - only takes derivative with respect to 'x'

;;; Advantages of using Scheme: Ability to find derivative with such short code:
(define d
  (λ (e x)
    (cond ((number? e) 0)
	  ((equal? e x) 1)
	  ((symbol? e) 0)
	  ((pair? e)
	   (let ((f (car e))) ; extra level of parenthesis for 'let' function
	     (apply (lookup f dtable)
		    (append (cdr e) (map (λ (u) (d u x)) (cdr e))))))
	  (else (error "bad LLE" le)))))

;;;dtable(data driven table) helps us deal with repeated 'cond' statements
;;;dtable allows us to abstract the condition
;;; dtable will have all the different type of mathematical expressions listed
(define dtable
  (list (list '+ (λ (u v du dv) (lle+ du dv))) ;x falls out of scope if du and dv are not used as arguments
	;; Leibnitz Rule: d(u*v) = u*dv + du*v
	(list '* (λ (u v du dv) (lle+ (lle* u dv) (lle* du v))))
	(list 'sin (λ (u du) (lle* (lle-cos u) du)))
	(list 'cos (λ (u du) (lle* (lle* -1 (lle-sin u)) du)))))

(define lookup
  (λ (x alist) ; association list
    (if (equal? x (caar alist))
	(cadar alist)
	(lookup x (cdr alist)))))

;;;Solution to having overly complex expressions:
;;; Define an lle+ and lle* function and check if the parameters are numbers
(define lle+
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (+ e1 e2))
	  ((equal? e1 0) e2)
	  ((equal? e2 0) e1)
	  (else (list '+ e1 e2)))))

(define lle*
  (λ (e1 e2)
    (cond ((and (number? e1) (number? e2))
	   (* e1 e2))
	  ((equal? e1 0) 0)
	  ((equal? e2 0) 0)
	  ((equal? e1 1) e2)
	  ((equal? e2 1) e1)
	  (else (list '* e1 e2)))))

;;;If we were writing in Java we'd use loops but with Scheme we write recursively
(define lle-sin
  (λ (e)
    (cond ((number? e) (sin e))
	  (else (list 'sin e)))))

(define lle-cos
  (λ (e)
    (cond ((number? e) (cos e))
	  (else (list 'cos e)))))

;;;we now have a table driven program
;;;Next time: write an interpreter in scheme

;;; aside: scheme tries to be regular & general.
;;; e.g., identity elements
;;; (+) = 0 - additive identity
;;; (*) = 1 - multiplicative identity
;;; (* x y z a b c) = (* (*) (* x y z a b c))

;;apply: calls function
;;map: calls function once for every element
;; > (apply + '(1 2 3))
;; 6

;; > (map sqrt '(0 1 2 3 4 5)) ;returns a list of the function applied to each element
;; (0 1 1.4142135623730951 1.7320508075688772 2 2.23606797749979)
;; > (map + '(0 1 2) '(10 20 30))
;; (10 21 32)

;;> (map / '(1 2 3))
;;'(1 1/2 1/3)

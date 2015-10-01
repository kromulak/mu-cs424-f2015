;;; Deficiencies:
;;;  - returns overly-complex expressions
;;;  - code is ugly

(define d
   (λ (e x)
     (cond ((number? e) 0)
	   ((equal? e x) 1)
	   ((symbol? e) 0)
	   (else
	    (let ((u (cadr e))
		  (v (caddr e)))
	      (cond ((equal? (car e) '+)
		     (lle+ (d u x) (d v x)))
		    ((equal? (car e) '*)
		     ;; Leibnitz Rule: d/dx u*v = u * dv/dx + du/dx * v
		     (lle+ (lle* u (d v x))
			   (lle* (d u x) v)))
		    (else (error "bad LLE" le))))))))

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

;;; aside: scheme tries to be regular & general.
;;; e.g., identity elements
;;; (+) = 0
;;; (*) = 1
;;; (* x y z a b c) = (* (*) (* x y z a b c))

;; > (apply + '(1 2 3))
;; 6

;; > (map sqrt '(0 1 2 3 4 5))
;; (0 1 1.4142135623730951 1.7320508075688772 2 2.23606797749979)
;; > (map + '(0 1 2) '(10 20 30))
;; (10 21 32)

;;; Deficiencies:
;;;  - returns overly-complex expressions
;;;  - code is ugly

(define d
  (λ (e x)
    (cond ((number? e) 0)
	  ((equal? e x) 1)
	  ((symbol? e) 0)
	  ((pair? e)
	   (let ((f (car e)))
	     (apply (lookup f dtable)
		    (append (cdr e) (map (λ (u) (d u x)) (cdr e))))))
	  (else (error "bad LLE" le)))))

(define dtable
  (list (list '+ (λ (u v du dv) (lle+ du dv)))
	;; Leibnitz Rule: d(u*v) = u*dv + du*v
	(list '* (λ (u v du dv) (lle+ (lle* u dv) (lle* du v))))
	(list 'sin (λ (u du) (lle* (lle-cos u) du)))
	(list 'cos (λ (u du) (lle* (lle* -1 (lle-sin u)) du)))))

(define lookup
  (λ (x alist)
    (if (equal? x (caar alist))
	(cadar alist)
	(lookup x (cdr alist)))))

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

(define lle-sin
  (λ (e)
    (cond ((number? e) (sin e))
	  (else (list 'sin e)))))

(define lle-cos
  (λ (e)
    (cond ((number? e) (cos e))
	  (else (list 'cos e)))))

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

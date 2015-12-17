;;; Represent set as list w/o repeated elements.

(define set-cardinality length)

;;; removes repeated elements
(define uniq
  (λ (xs)
    (if (null? xs)
	xs
	(let ((ys (uniq (cdr xs))))
	  (if (member (car xs) ys)
	      ys
	      (cons (car xs) ys))))))

(define set-union (λ (s1 s2) (uniq (append s1 s2))))

(define set-intersection
  (λ (s1 s2)
    (cond ((null? s1) s1)
	  ((member (car s1) s2)
	   (cons (car s1)
		 (set-intersection (cdr s1) s2)))
	  (else (set-intersection (cdr s1) s2)))))

(define set-difference
  (λ (s1 s2)
    (cond ((null? s1) s1)
	  ((member (car s1) s2)
	   (set-difference (cdr s1) s2))
	  (else (cons (car s1) (set-difference (cdr s1) s2))))))

(define set-equal?
  (λ (s1 s2) (and (null? (set-difference s1 s2))
		  (null? (set-difference s2 s1)))))

(define set-map-join
  (λ (f s)
    (foldl set-union '() (map f s))) )

(define free-variables
  (λ (e)
    (cond ((symbol? e) (list e))	; var
	  ((equal? (car e) 'λ)		; λ expression
	   (let ((param (cadr e))
		 (body (caddr e)))
	     (set-difference (free-variables body)
			     (list param))))
	  (else 			; application
	   (set-union (free-variables (car e))
		      (free-variables (cadr e)))))))

(define β-reduce
  (λ (e)
    (cond ((symbol? e) #f)	; var
	  ((equal? (car e) 'λ)		; λ expression
	   (let ((param (cadr e))
		 (body (caddr e)))
	     (cond ((β-reduce body) => (λ (brb) (list 'λ param brb)))
		   (else #f))))
	  (else 			; application
	   (let ((e1 (car e))
		 (e2 (cadr e)))
	     (cond ((β-reduce e1) => (λ (bre1) (list bre1 e2)))
		   ((β-reduce e2) => (λ (bre2) (list e1 bre2)))
		   ((and (pair? e1)
			 (equal? (car e1) 'λ))
		    (let ((param (cadr e1))
			  (body (caddr e1)))
		      replace-in-term param e2 body))
		   (else #f)))))))


(define replace-in-term
  (λ (old new e)
    (cond ((equal? old e) new)		;e is target variable
	  ((symbol? e) e)		;e is non-target variable
	  ((equal? (car e) 'λ)		;e is λ expression
	   (let ((param (cadr e))
		 (body (caddr e)))
	     (cond ((equal? old param) e)
		   ((member param (free-variables new))
		    (let ((nv (gensym)))
		      (list 'λ
			    nv
			    (replace-in-term old new
					     (replace-in-term param nv body)))))
		   (else (list 'λ param (replace-in-term old new body))))))
	  (else 			;e is application
	   (list (replace-in-term old new (car e))
		 (replace-in-term old new (cadr e)))))))

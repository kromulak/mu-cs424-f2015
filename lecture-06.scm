;;; Meta-Circular Interpreter in Scheme

;;; eval is built-in interpreter, avoid namespace collision
;; > (eval (list '+ 1 2))
;; 3

(define my-eval
  (λ (e)
    (cond ((number? e) e)
	  ((equal? (car e) '+)
	   (+ (my-eval (cadr e)) (my-eval (caddr e))))
	  ((equal? (car e) '*)
	   (* (my-eval (cadr e)) (my-eval (caddr e))))
	  (else (error "bad expression" e)))))

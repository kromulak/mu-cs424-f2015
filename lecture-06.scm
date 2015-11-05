;;; Meta-Circular Interpreter in Scheme

;;; eval is built-in interpreter, avoid namespace collision
;; > (eval (list '+ 1 2))
;; 3

;;; my-eval needs to evaluate the environment for the local variables.
;;; Has to check in both the local environment and the global environment.
(define my-eval
  (λ (e env)
    (cond ((or (number? e) (boolean? e)) e)
	  ((symbol? e) (lookup e (append env global-env)))
	  ((pair? e) ;;; Ensure that we have a non-empty list
	   (let ((f (car e)))
	     (cond ((or (equal? f 'λ) (equal? f 'lambda)) ;;; check for special functions, lambda, let, etc.
		    (let ((vars (cadr e))
			  (body (caddr e)))
		      (list 'closure vars body env)))
		   ((equal? f 'let)
		    ;; MACRO:
		    ;;  (let ((VAR EXPR)...) BODY)
		    ;;    ==> ((λ (VAR...) BODY) EXPR...)
		    (my-eval (let ((bindings (cadr e))
				   (body (caddr e)))
			       (cons (list 'λ (map car bindings) body)
				     (map cdr bindings)))
			     env))
		   (else
		    ;; regular function call
		    (my-apply (my-eval f env)
			      (map (λ (a) (my-eval a env))
				   (cdr e)))))))
	  (else (error "bad expression" e)))))

;;; Takes in a procedure and args.
;;; Checks if p is already a procedure.
(define my-apply
  (λ (p args)
    (cond ((procedure? p) (apply p args))
	  ((and (pair? p) (equal? (car p) 'closure))
	   (my-eval (caddr p) (append (map list (cadr p) args)
				      (cadddr p))))
	  (else (error "xxx")))))

(define lookup (λ (k alist) (cadr (assoc k alist))))
;;; assoc: checks a key and an association list
;;; Returns the two element list or false if nothing is found

(define global-env (list (list '+ (λ (x y) (+ x y)))
			 (list '* (λ (x y) (* x y)))
			 (list 'sin sin)))
			 
;;; OTHER POINTS
;;; "member" returns a list starting with the element found
		;;; i.e. member 'b '(a b c d) returns (b c d)
;;; It returns false if the element is not found in the list
		;;; i.e. member 'z '(a b c d) returns #f
		
;;; "if" will return true (#t) for any value that is not explicitly false
	;;; i.e. if(1) will evaluate to true


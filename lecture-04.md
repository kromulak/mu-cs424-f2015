# Lecture 04

##Deficiencies in Lecture 03 code
* returns overly-complex expressions
* code is ugly
* only takes derivative with respect to 'x'

## Advantages of using Scheme

* Ability to find derivative with such short code: 
```
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
		     ;; Leibniz Rule: d/dx u*v = u * dv/dx + du/dx * v
		     (list '+
			   (list '* u (d/dx v))
			   (list '* (d/dx u) v)))
		    (else (error "bad LLE" le))))))))
 ```

*   Scheme is not designed for programming at large.
*   Scheme has no abstraction barriers

## Returning over complex expressions solution
* Define an lle+ and lle*
```
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
```
##Code Abstraction
* If there is a possibility for abstraction then take it (this is how you keep your job)
* dtable(data driven table) allows us to abstract multiple 'cond' statements

##map & apply			
* Built in function: map
```
> (map sqrt '(0 1 2 3 4 5))
(0 1 1.4142135623730951 1.7320508075688772 2 2.23606797749979)
```

* map & apply: completely different
* 'apply' calls function
* 'map' calls function once for every element
```
 (apply +'(1 2 3))
	  >6
	  
 (map + ' (1 2 3))
	  > ( 1 2 3)
```

##list

* Check if something is a list:
```
list? 
pair?
```
* An empty list is  a list but its not a pair.

##Scheme Niceties

* exploratory programming (don't have to be consistent)
* bottom up programming (Just start writing table and see what happens)
```
(define dtable
  (list (list '+ (λ (u v du dv) (lle+ du dv))) ;x falls out of scope if du and dv are not used as arguments
	;; Leibnitz Rule: d(u*v) = u*dv + du*v
	(list '* (λ (u v du dv) (lle+ (lle* u dv) (lle* du v))))
	(list 'sin (λ (u du) (lle* (lle-cos u) du)))
	(list 'cos (λ (u du) (lle* (lle* -1 (lle-sin u)) du)))))
```

Leibniz Rule : ![Leibniz Rule] (https://upload.wikimedia.org/math/b/d/c/bdcb07184715b984c8f7781bc6e30841.png)


* If we were writing in Java we'd use loops
* Scheme: write recursively


* Next time: write an interpreter

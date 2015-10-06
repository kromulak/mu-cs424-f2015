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

Doesn't like 'cond' because we end up with repeated code.
Possibility of abstraction (how you keep your job)


Deal with abstraction
data driven (table driven)
procedures

e.g. table driven				don't have a readable expression(?)
								(list 'sin sin 'cos cos)
			
Built in function: map
map (sqrt '(0 1 2 3 4 5 6 7 8 9))
>returns list of each of the list
				*map reduce
				
Map: like cross product(?)

* map & apply: completely different
apply calls function
map calls function once for every element

e.g. (apply +'(1 2 3))
	  >6
	  (map + ' (1 2 3))
	  > ( 1 2 3)
	  
	  (map / '(1 2 3))
	  > (1/1 1/2 1/3)  (?)

Current code: doesn't like being able to only take....

Rethink dispatch: make a table
Functions which will take the parts of the lle and do something


Check if something is a list:
list? pair?

An empty list is  a list but its not a pair.

If e's a pair then we'll do a dispatch on it // let ((f car e)) extra level of parenthesis for 'let' function

LOOKUP f in a  table
> result of lookup should be some function which will call

to call LOOKUP we'll need to give it some arguments

* Nice thing about scheme: exploratory programming (don't have to be consistent)
- bottom up programming
Just start writing table and see what happens

<!--#define dtable-->

dtable will have all the different type of mathematical expressions listed

Leibniz Rule : <!-- math exp du/dv etc.-->

x is out of scope in dtable so lets take extra arguments such as du and dv

(append (cdr e) (map(lambda(u)) (d ux) cdr e))

define lookup
alist: association list

If we were writing in Java we'd use loops
Schem: write recursively

Searching for a key in table
returning value

If returned value matches key then
(if (equal CODE CODE CODE ETC.))

Finish it and start again so no definitions are still loadded

CODE CODE CODE


We now have a table driven program

Next time: write an interpreter in scheme for scheme
Auto-cat: extension language(?)

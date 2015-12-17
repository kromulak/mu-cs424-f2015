MU CS424, Fall 2015
-------------------
Assignment 1: Scheme
====================

In this assignment, you will write some Scheme code.

Please make sure it runs in "mzscheme", which is the Scheme
interpreter in the Racket system, http://racket-lang.org, which I have
been running in isolation in class.  I've been writing the code in
Emacs, and running mzscheme from inside Emacs with ```M-x
run-scheme```.  You are welcome to use the full Racket development
environment instead, should you so desire.  In fact you are welcome to
do your development however you wish; just make sure you turn it in
as:

* a *single* file
* without anything unusual (like spaces or unicode) in the filename
* with extension .scm
* that loads and runs in mzscheme so I can test it
* that includes a definition of ```test-it``` which runs your own test suite
* and, if applicable, that passes my test suite.

Also:

* Programming in Scheme should be *fun!*  Therefore ...
* No error checking: if it "takes a *foo*" or "is given a *foo*" you can assume its input is indeed a *foo.*  And if the input isn't a foo it's okay if monkeys come out of the user's nose, not your problem.
* Comments are optional: get a grip, take a breath, write the code.
* Please don't make up your own strange whitespace conventions: if you're really bored enough to do that maybe you can help me unpack the boxes in my office?

Other useful documentation is

* the R4RS manual, http://community.schemewiki.org/?R4RS
* any of the many tutorials and such available on http://www.schemers.org/.
* *The Little Schemer* is a nice text on Scheme.
* There is a wikibooks text, https://en.wikibooks.org/wiki/Scheme_Programming

Please use only the "pure" subset of the language, meaning: nothing
with an ```!``` in it, no side effects, no I/O.

(a) Finger Exercises
--------------------
We represent a *set* as a list of unique elements, i.e., no duplicate
elements, with order being irrelevant.  So the set *{a,b,c}* could be
represented as the list ```(c b a)``` or ```(a c b)```, but ```(a b c
c)``` would be wrong.

Define the following functions:

* ```(set-cardinally s)``` returns the number of elements in the set ```s```.

* ```(set-union s1 s2)``` and ```(set-intersection s1 s2)``` and
  ```(set-difference s1 s2)``` return the union, intersection, and set
  difference (i.e., set of elements in s1 but not in s2) of the given
  sets.

  *Example:*

  ```(set-union '(a b c d e) '(c d e f g))``` ⇒ ```(b d a c e g f)```

* ```(set-equal? s1 s2)``` determines whether the two sets it is
  passed are equal.

* ```(set-map-join f s)``` applies the function ```f``` to each
  element of the set ```s```.  The function ```f``` should itself
  return a set.  The result of ```set-map-join``` is the union of all
  such sets.

	*Example:*

    ```(set-map-join (λ (e) (list (+ e 1) (* e 10))) '(1 2 3 4))```
	⇒ ```(3 2 10 4 40 5 20 30)```

(b) λ Calculus Manipulation
--------------------------------
We represent λ-calculus terms as Scheme s-expressions, with variables
as symbols, an application _E1 E2_ as ```(```_E1_``` ```_E2_```)```,
and a λ expression _λ v . E_ as the s-expression ```(λ ```_v_``` ```_E_```)```.

* Define ```(free-variables e)``` which returns the set (represented
  as a list without duplicates) of free variables in the term
  represented by ```e```.

  *Example:*

  ```(free-variables '((a b) (λ c ((d c) (e b)))))```
  ⇒ ```(a b d e)```

* Define ```(β-reduce e)``` which, when a β-reduction is possible (i.e.,
  when ```e``` is of the form
  ```((λ ```_v_``` ```_e1_```) ```_e2_```)```
  and there are no free variable conflicts that block the β-reduction
  and would require some α-renaming first) returns the result of the
  β-reduction, and otherwise returns ```#f```.

  *Example:*

  ```(β-reduce '((λ x (((λ x (x y)) x) (x b))) z))```
  ⇒ ```(((λ x (x y)) z) (z b))```

  ```(β-reduce '((λ x (((λ y (x y)) x) (x b))) y))```
  ⇒ ```#f```

# Hints

Your test function might look something like this:
````scheme
;;; Returns list of failed test cases.
(define test-it
  (λ ()
    (define iota (λ (n)
                   (define iota0 (λ (i) (if (= i n) '() (cons i (iota0 (+ i 1))))))
                   (iota0 0)))
    (define tests
      (list (λ () (set-equal? (set-union '(a b c d e) '(c d e f g))
                              '(b d a c e g f)))
            (λ () (set-equal? (free-variables '((a b) (λ c ((d c) (e b))))) '(a b d e)))
            (λ () (set-equal? (free-variables '((λ y y) (λ x y))) '(y)))
			))
    (filter number?
            (map (λ (t i) (if (t) #f i))
                 tests
                 (iota (length tests))))))
````

# Due 5pm (17:00) Friday 20-Nov-2015

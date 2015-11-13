;;;Introduction to Lambda Calculus

;;;Slides can be found here: http://www-verimag.imag.fr/~iosif/LogicAutomata07/lambda-calculus-slides.pdf
;;; Covers: 
;;; Synatic sugar in lambda calculus
;;; α-conversion/α-renaming
;;; scoping & parameter passing
;;; β-reduction
;;; -> note that the way of writing β-reduction in the slides is the standard way, but not the way Barak writes it in class.
;;;The Church-Roser Theorem -> if we apply x and y to a to get b and c, we can apply y to a and x to b and both will equal d.
;;;


;;; Church-Encoding Natural Numbers (continued)

(define zero  (λ (f) (λ (x) x)))
(define one   (λ (f) (λ (x) (f x))))
(define two   (λ (f) (λ (x) (f (f x)))))
(define three (λ (f) (λ (x) (f (f (f x))))))

;;;"succ" named "inc" in lecture12 notes
(define succ  (λ (n) (λ (f) (λ (x) (f ((n f) x)))))) ; traditional name: successor

(define plus1 (λ (x) (+ x 1)))
(define church-to-int (λ (n) ((n plus1) 0)))

;;; Representing Booleans
(define true   (λ (x) (λ (y) x)))
(define false  (λ (x) (λ (y) y)))

;;;encoding pairs in Lambda Calculus is similar to cons in scheme
(define pair (λ (x) (λ (y) (λ (b) ((b x) y)))))
(define fst  (λ (p) (p true)))
(define snd  (λ (p) (p false)))

;; > (church-to-int (fst ((pair two) three)))
;; 2
;; > (church-to-int (snd ((pair two) three)))
;; 3

;;;I is the identity combinator
(define I      (λ (x) x))
;;;K is the constant combinator
(define K      (λ (x) (λ (y) x)))

;;;note that as an alternative to Lambda Calculus, we can use combinator logic/SKI-calculus, which only uses the cambinators I, K and S
;;;Combinator Logic is also Turning complete.

(define iszero (λ (n) ((n (K false)) true)))
;;;When checking if a number is zero, if we apply the number to iszero 0 times, we get true, apply it more times and false is returned.

(define church-to-bool (λ (b) ((b #t) #f)))

;; > (church-to-bool (iszero zero))
;; #t
;; > (church-to-bool (iszero one))
;; #f
;; > (church-to-bool (iszero two))
;; #f

;; pred = λ n f x . snd
;;                   (n (λ p . if (fst p)
;;                                (pair false (snd p))
;;                                (pair false (f (snd p))))
;;                      (pair true x))

;;;We defined successor and now we want predecessor.
;;;Apply the function n-1 times to return the predecessor. 

(define pred				; predecessor
  (λ (n)
    (λ (f)
      (λ (x)
	(snd ((n (λ (p) (((fst p)
			  ;; "then" clause
			  ((pair false) (snd p)))
			 ;; "else" clause
			 ((pair false) (f (snd p))))))
	      ((pair true) x)))))))

;; > (church-to-int (pred three))
;; 2
;; > (church-to-int (pred two))
;; 1
;; > (church-to-int (pred one))
;; 0
;; > (church-to-int (pred zero))
;; 0

;;;Now that we have defined pred, we can subtract. 
;;;To subtract m from n, we need to apply pred to n, m times.
(define subtract (λ (n) (λ (m) ((m pred) n))))

;; > (church-to-int ((subtract three) two))
;; 1
;; > (church-to-int ((subtract three) three))
;; 0

;; Looping Construct

;; Y Combinator
;; finds fixed point

;; Y f = f (Y f)
;; Y = λ f . (λ x . f (x x)) (λ x . f (x x))


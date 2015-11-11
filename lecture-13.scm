;;; Church-Encoding Natural Numbers (continued)

(define zero  (λ (f) (λ (x) x)))
(define one   (λ (f) (λ (x) (f x))))
(define two   (λ (f) (λ (x) (f (f x)))))
(define three (λ (f) (λ (x) (f (f (f x))))))

(define succ  (λ (n) (λ (f) (λ (x) (f ((n f) x)))))) ; traditional name: successor

(define plus1 (λ (x) (+ x 1)))
(define church-to-int (λ (n) ((n plus1) 0)))

(define true   (λ (x) (λ (y) x)))
(define false  (λ (x) (λ (y) y)))

(define pair (λ (x) (λ (y) (λ (b) ((b x) y)))))
(define fst  (λ (p) (p true)))
(define snd  (λ (p) (p false)))

;; > (church-to-int (fst ((pair two) three)))
;; 2
;; > (church-to-int (snd ((pair two) three)))
;; 3

(define I      (λ (x) x))
(define K      (λ (x) (λ (y) x)))

(define iszero (λ (n) ((n (K false)) true)))

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

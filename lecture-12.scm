;;; Lambda calculus - Modelling the Natural Numbers

;;; First two: equivalent up to α-renaming, second to are not.
;;; a (λ x . x)
;;; a (λ y . y)
;;; b (λ y . y)

;;; Church-encoded natural numbers:

;;;  zero  = λ f . λ x . x           = λ f x . x
;;;  one   = λ f . λ x . f x         = λ f x . f x
;;;  two   = λ f . λ x . f (f x)     = λ f x . f (f x)
;;;  three = λ f . λ x . f (f (f x)) = λ f x . f (f (f x))

;;; Increment a number by one:
;;;  inc = λ n . λ f x . f (n f x)
;;;  inc = λ n . λ f x . n f (f x)  [should be equivalent]

;;; Want to show:
;;;  inc zero ↝ one
;;;  (λ n . λ f . λ x . f (n f x)) (λ f . λ x . x)
;;;   ↝ [n↦(λ f . λ x . x)](λ f . λ x . f (n f x))
;;;   = λ f . λ x . f (((λ f . λ x . x) f) x)
;;;   ↝ λ f . λ x . f ([f↦f](λ x . x) x)
;;;   = λ f . λ x . f ((λ x . x) x)
;;;   ↝ λ f . λ x . f ([x↦x]x)
;;;   = λ f . λ x . f x
;;;  which is the same as one.  QED

;;; Add two numbers:
;;;  add = λ n m . n inc m
;;;  add = λ n m . m inc n
;;;  add = λ n m . λ f x . m f (n f x)

;;;  compose = λ f g . λ x . f (g x)

;;;  add = λ n m . λ f . compose (n f) (m f)

;;; Multiply two numbers:
;;;  mul = λ n m . λ f . n (m f)

;;; Exponentiation:
;;;  expon = λ n m . m (mul n)   [THIS HAS A BUG SEE BELOW!]

(define zero  (λ (f) (λ (x) x)))
(define one   (λ (f) (λ (x) (f x))))
(define two   (λ (f) (λ (x) (f (f x)))))
(define three (λ (f) (λ (x) (f (f (f x))))))

(define inc   (λ (n) (λ (f) (λ (x) (f ((n f) x))))))

(define plus1 (λ (x) (+ x 1)))
(define church-to-int (λ (n) ((n plus1) 0)))

;; > (church-to-int zero)
;; 0
;; > (church-to-int two)
;; 2
;; > (church-to-int three)
;; 3
;; > (church-to-int (inc three))
;; 4
;; > (church-to-int (inc (inc three)))
;; 5

;;; composition of functions
(define comp (λ (f) (λ (g) (λ (x) (f (g x))))))

(define add (λ (n) (λ (m) ((n inc) m))))

;; > (church-to-int ((add two) three))
;; 5

(define mul (λ (n) (λ (m) (λ (f) (n (m f))))))

;; > (church-to-int ((mul two) three))
;; 6

;;; This has a bug:
(define expon (λ (n) (λ (m) (m (mul n)))))
;; > (church-to-int ((expon one) zero))
;; 1
;; > (church-to-int ((expon two) zero))
;; 1
;; > (church-to-int ((expon two) one))
;; #<procedure:...4/lecture-12.scm:47:21>

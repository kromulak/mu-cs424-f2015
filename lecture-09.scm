;;; Migration of things out of the core and into library functions & macros.
;;; Or, writing things at user level instead of as internal magic system things.

;;; CPS - migrates "non-TR procedure calls" out

;;; Define data structures at user level.

;;; Lists.

;;; List API
;;;  functions: cons, car, cdr
;;;  (car (cons a d)) = a
;;;  (cdr (cons a d)) = d

(define kons (λ (a d) (λ (x) (x a d))))
(define fst (λ (a d) a))
(define snd (λ (a d) d))
(define kar (λ (p) (p fst)))
(define kdr (λ (p) (p snd)))

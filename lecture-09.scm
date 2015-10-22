;;; Migration of things out of the core and into library functions & macros
;;; Or, writing things at user level instead of as internal magic system things.

;;; CPS - migrates "non-TR procedure calls" out

;;; Define data structures at user level.

;;; Lists.

;;; List API
;;; 	functions: cons, car, cdr
;;; 	(car (cons a d)) = a
;;; 	(cdr (cons a d)) = d

(define kons (λ (a d) (λ (x) (x a d))))
(define fst (λ (a d) a))
(define snd (λ (a d) d))
(define kar (λ (p) (p fst)))
(define kdr (λ (p) (p snd)))

;;; Object System defined using λ

(define send (λ (obj selector . args)
			(apply obj `(, obj ,selector ,@args))))

;;; Make a complex number represented as real & imaginary parts
(define make-rect
	(λ (re im)
		(λ (self selector . args)
			(cond ((equal? selector '+) (make-rect (+ re (send (car args) 'real-part))
														  (+ im (send (car args) 'imag-part))))
				  ((equal? selector '*) 
					(let ((y (car args))))
					  (let ((re-y (send y 'real-part))
							(im-y (send y 'imag-part)))
						(make-rect (- (* re re-y) (* im im-y))
										  (+ (* re im-y) (* im re-y)))))
				  ((equal? selector 'real-part) re)
				  ((equal? selector 'imaginary-part) im)
				  ((equal? selector 'abs) (sqrt (+ (* re re) (* im im))))
				  ((equal? selector 'phase) (atan im re))
				  (else (error "unknown operation" selector))))))

(define ii (make-rect 0 1)) ;; makes a complex number with a real and imaginary element
(define complex-minus-one (send ii '* ii))

;;; Make a complex number represented as magnitude & phase
(define make-polr
	(λ (mag phase)
		(λ (self selector . args)
			(cond ((equal? selector '+) xxx)
				  ((equal? selector '*)
					(make-polr (* mag (send (car args) 'abs))
							   (let ((phase0 (+ phase
												(send (car args) 'phase))))
								(cond ((< phase0 0) 
									   (+ phase0 (* 2 pi)))
									  ((>= phase0 (* 2 pi))
									   ( - phase0 (* 2 pi)))
									  (else phase0)))))
				  ((equal? selector 'abs) mag)
				  ((equal? selector 'phase) phase)
				  ((equal? selector 'real-part) (* mag (cos phase)))
				  ((equal? selector 'imag-part) (* mag (sin phase)))
				  (else (error "unknown operation" selector))))))

(define complex-sqrt (λ (z) (make-polr (sqrt (send z 'abs))
									   (/ (send z 'phase) 2))))
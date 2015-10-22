;;; Migration of semantic constructs to "user level"
;;; - local variable binding (macro expand let into ((λ...)...))
;;; - conditionals like if (macro expand into clopsures & library function or lambda/λ-expressions)
;;; - goto, loops (tail-recursive procedure call)
;;; - non-tail-recursive procedure call (use continuations; convert to CPS)
;;; - data structures (implement as closures) [L09]
;;; - objects (closures) [L09]
# Polymorphic λ Calculus aka System F

In simply typed λ calc, can only have grounded types:

	λ x:Bool . x
	
	λ x:Real . x
	
	λ x:(Bool->Bool) -> (Real->Real->Real) . x
	
We now want to write identity function with polymorphic type.

Something like:

	λ x . x : forall a => a->a
	
In system F:

	CAPITAL LAMBDA a . λ x . x
	
CAPITAL LAMBDA is like λ but accepts a "type" argument

	(CAPITAL LAMBDA a . λ x : a . x) Real
	~> λ x : Real .x
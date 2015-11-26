# Polymorphic λ Calculus aka System F

In simply typed λ calc, can only have grounded types

    λ x:Bool . x

    λ x:Real . x

    λ x:  (Bool->Bool) -> (Real->Real->Real) . x

Want to write identity function with polymorphic type.

Something like:

    λ x . x : forall a => a->a

In system F:

    Λ a . λ x : a . x

Λ is like λ but accepts a "type" argument

    (Λ a . λ x : a . x) Real
    ↝ λ x : Real . x

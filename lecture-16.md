# Simply Typed λ Calculus --- Subtyping and Records

We have a notion of a properly-typed expression. There's typing over a λ-expression (where you declare the form of the parameter) and typing over applications.

Type of an application
````
Γ |- f : A -> B			Γ |- x : A
----------------------------------
			 Γ |- f x : B
````

What is a subtype?
==================
We're going to define a relationship between two types, where type A is a subtype of type B:

A <= B means A is a subtype of B

Could use (SUBSET OR EQUAL TO SYMBOL)

Example: Int <= Real

Transitive: if A <= B and B <= C then A <= C

In programming language, we want to have:
````
sin : Real -> Real
pi : Real
1 : Int
````
We want ```sin 1``` to be okay.

Type of an application *with subtypes*:
````
Γ |- f : A -> B		Γ |- x : A'		Γ |- A' <= A
------------------------------------------------
				   Γ |- f x : B
````

Subtype axioms:
````
-------------------
	Int <= Real
````
	
Can write transitiveness as
````
A <= B			B <= C
----------------------
		A <= C
````

Consider ```map : (Real -> Char) -> (Int -> Real) -> (Int -> Char)``` or if we write ```Seq T``` as shorthand for ```(Int -> T)```, a sequence of ```T```s, then ```map : (Real -> Char) -> Seq Real -> Seq Char```

Intuition: if A <= B then wherever the program wants an object of type B you can give it an A and everything is fine.

When is A -> B <= C -> D?

A -> B <= C -> when:
* C <= A (more liberal in what it is expecting)
* B <= D (more stringent in what it outputs)

````
A >= C	B <= D
--------------
 A->B <= C->D
````

Record Types
============
Add record type to Simply Typed λ Calculus

Term ::= ... | Record | Term.Selector

Record ::= { Selector |-> Term * }
 where the * means zero or more separated by commas
 
Type ::= ... | { Selector : Type * }

write point with x & y coords as ```{x|->1, y|->2} : {x:Real, y:Real} ```

Typing Rules for Records
------------------------
Type of empty record:
````
------------
Γ |- {} : {}
````
Type of a record with a selector s:
````
  Γ |- R : {RT...}     Γ |- e:A
  ------------------------------
  Γ |- {R..., s|->e} : {RT..., s:A }
````
Type of a term which accesses record with selector s:
````
  Γ |- {s|->e}:{s:A}
  ------------------
	 Γ |- e.s : A
````
Subtyping of records:
````
				T1' <= T1	T2' <= T2	...		Tn' <= Tn
-----------------------------------------------------------------------------
{s1:T1', s2:T2', ..., sn:Tn', s{n+1}:T(n+1), ...}<={s1:T1, s2:T2, ..., sn:Tn}
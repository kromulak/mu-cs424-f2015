# Simply Typed Lambda Calculus

#### New formal system

λ calculus = untyped<br>
λ<sup>→</sup> calculus = simply typed 

Want to augment the λ Calculus with types.
This requires:
 * adding types to the grammar,
 * adding basis objects (like numbers and operations thereupon) to the grammar, and
 * mechanisms for figuring out what type a term has.

#### Grammar
e :: = v | e e | λ v: τ . e | b<sub>1</sub> | b<sub>2</sub> | ...<br>
τ :: = τ → τ | t<sub>1</sub> | ... | t<sub>m</sub>

This is the same as the untyped lambda calculus, except we have added some "basis objects" as terms and a new "type" construct, which can be either a "basis type" or a function type, and we have added a type declaration slot after the formal parameter following a λ.

For concreteness, we will take the basis objects to be numbers (0, 1, ...), numeric operators (plus, times, isZero), and booleans (false, true). And we will take the basis types to be **bool** and **int**.

#### Example terms:
x y z = (x y) z<br>
(times true) false

#### Example type:
**bool** → **int** → **int** = **bool** → (**int** → **int**)

Note that the associativity of application (in the example term x y z) is on the left while the association of function types is on the right (in the example type). This makes curried functions and their types work right without parenthesis.

#### Reductions
Beta reduction stays the same, just drops the type.

(λv:t . e<sub>1</sub>) e<sub>2</sub> ↝ [v ↦ e<sub>2</sub> ] e<sub>1</sub>

This implies *The Erasure Theorem*: that any well-typed term in the simply typed lambda calculus will reduce to the same thing if you drop the types and reduce it in the untyped lambda calculus.

We also need to add reductions for the newly introduced basis objects. Like

plus 2 3 ↝ 5<br>
isZero 2 ↝ false

####Typing Rules:

We use Γ (a capital gamma) for a type environment, which is simply a mapping from symbols (basis symbols and variables) to types, (Γ : symbol → type). We write "Γ, v:τ" for the type environment Γ augmented with a mapping from v to τ. We use Γ ⊢ e : τ for the logical statement that, in the type environment Γ it can be shown that the term e has type τ. As in predicate calculus, we write assumptions above a horizontal line and consequences below.

Type "axioms", if v:τ or b:τ is in Γ, then Γ ⊢ v:τ or  Γ ⊢ b:τ, respectively.

Type rule for an application:
````
Γ ⊢ e1: τ → τ'        Γ ⊢ e2:τ
------------------------------
       Γ ⊢ e1 e2 : τ
````

Type inference for a lambda expression:
````
      Γ, v:τ ⊢ e:τ'
-----------------------
  Γ ⊢ (λv:τ . e): τ →  τ'
````

#### Type example
We will use the above to find the type of the term (λ x:int . λ y:bool . x) 3 false
````

Γ, x:int, y:bool ⊢ x:int
--------------------------
Γ,x:int ⊢ λ y:bool . x : bool → int
-----------------------------------
Γ ⊢ (λ x:int . λ y:bool . x ):int → bool → int     Γ ⊢ 3:int
------------------------------------------------------------
Γ ⊢ (λ x:int . λ y:bool . x) 3 : bool → int                         Γ ⊢ false:bool
----------------------------------------------------------------------------------
Γ ⊢ (λ x:int . λ y:bool . x) 3 false : int
````

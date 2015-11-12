# Simply Typed Lambda Calculus

λ   calculus = untyped
λ→ calculus = simply typed 

e :: = v | e e | λ v: τ . e | b1 | b2 | ... |bn
τ :: = int | bool | τ → τ 

(λv:t . e1 ) e2 ↝ [v ↦ e2 ] e1   V ∈ FV(e2)

x y z = (x y)z
(times true) false
bool → int → int= bool → (int → int)

add v: τ
(Γ : vars → types)

Typing Rules:
Γ ⊢ e1 e2 :  τ'

Γ ⊢ e1: τ → τ', Γ ⊢ e2:τ      ||     Γ, v:τ  e:τ'
------------------------      || -----------------------
   Γ ⊢ e1 e2 : τ'             ||  Γ ⊢ (λv : τ.e) τ →  τ'

λx . λy . if x y (plus y 1)

   int  bool  int
(λ  x .  λy  . x  ) 3 false

Γ, x:int , y:bool ⊢ x:int
--------------------------
Γ,x:int ⊢ λy . x:bool → int
--------------------------
Γ ⊢ (λx . λy . x ):int → bool → int 
---------------------------
Γ ⊢ (λx . λy . x) 3 : false) : int 

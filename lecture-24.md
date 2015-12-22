# Lecture 24
17/12/2015

## Write a Unifier Function
* We'll write it in Haskell

  
* Define what we're unifying:
  ```
  data Term = Term String [Term] | Hole LogicVariable
          deriving (Eq, Show)
  ```

* What does it mean to unify?
  A mechanism to bind logical variables:
  ```
  type Unifier = [(LogicVariable,Term)]
  ```
  
  **type**: introduces a synonym for a type and uses previously defined data constructors


* What happens if you try to unify two terms which can't be unified?
  Necessary to return `Maybe Unifier`:
  ```
  unify :: Term -> Term -> Unifier -> Maybe Unifier
  ```
  
###Test

	  
	  unify (Term s1 []) (Term s2 []) u
	   = if s1==s2 then Just u else Nothing
	 
	  >unify (Term "foo" []) (Term "bar" []) []
	  Nothing
	  
	  >unify (Term "foo" []) (Term "foo" []) []
	  Just []
	  



* If we're unifying two empty lists then we're done:
  ```
  unifyLists [] [] u = Just u
  ```
  
* What if lists are different lengths?
  Unification fails:
  ```
  unifyLists _ _ _ = Nothing
  ```
  
###Code Comments
*   `unify (Hole lvA) b@(Term bHead bArgs) u` -- binds three variables and 'b' to the second term
*   `maybe (Just ((lvA,b):u)) (\t->unify t b u)` -- what it found will be unified with 'b'
*	`_bHead` -- not looking for that value; just looking for that shape
*   `unify a@(Term _aHead _aArgs) b@(Hole _lvB) u = unify b a u` -- unification is symmetric
*   `(_, Nothing)           -> Just ((lvB,a):u)` -- takes 'u' and binds to a logical variable B
   
* A variable which is **uninstantiated** can be unified with an atom
  If one variable is a hole then we'll give it a value:
  ```
  >unify (Term "foo" [Hole 1]) (Term "foo" [Term "bar" []]) []
  Just [(1, Term "bar" [])]
  ```
  
###Unification Test
  ```
  >unify (Term "foo" [Hole 1,Term "zonk" [],Hole 3]) (Term "foo" [Term "bar" [],Hole 2,Term "baz" []])[]
  Just [(3,Term "baz" []),(2,Term "zonk" []),(1,Term "bar" [])]
  ```
  
###Lookup
  ```
  >:t lookup
  lookup :: Eq a => a -> [(a, b)] -> Maybe b
  
  >lookup 3 [(1,'a'), (3,'b')]
  Just 'b'
  ```

###Undefined
* Instead of commenting out an undefined variable; use term **undefined**: 

  ```
  unify (Term aHead aArgs) (Hole lvB) u = undefined
  ```
* Compilers will recognise this and insert appropriate error message
  
##Conclusion
* Unification is like writing an **equality check**
* [Unify.hs] (https://github.com/barak/mu-cs424-f2015/blob/master/Haskell/Unify.hs)

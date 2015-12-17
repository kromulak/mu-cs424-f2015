data Term = Term String [Term] | Hole LogicVariable
          deriving (Eq, Show)

type LogicVariable = Int

type Unifier = [(LogicVariable,Term)]

unify :: Term -> Term -> Unifier -> Maybe Unifier

unify (Term aHead aArgs) (Term bHead bArgs) u
  = if aHead == bHead
    then unifyLists aArgs bArgs u
    else Nothing

unify (Hole lvA) b@(Term _bHead _bArgs) u =
  maybe (Just ((lvA,b):u)) (\t->unify t b u) (lookup lvA u)
unify a@(Term _aHead _aArgs) b@(Hole _lvB) u = unify b a u
unify a@(Hole lvA) b@(Hole lvB) u =
  case (lookup lvA u, lookup lvB u) of
    (Nothing, _)           -> Just ((lvA,b):u)
    (_, Nothing)           -> Just ((lvB,a):u)
    (Just lvAv, Just lvBv) -> unify lvAv lvBv u

unifyLists :: [Term] -> [Term] -> Unifier -> Maybe Unifier

unifyLists [] [] u = Just u
unifyLists (a:as) (b:bs) u = unify a b u >>= unifyLists as bs
unifyLists _ _ _ = Nothing

{- -- Examples

-- These should unify:
unify (Term "foo" []) (Term "foo" []) []
 --> []

unify (Hole 1) (Term "foo" []) []
 --> Just [(1,Term "foo" [])]

unify (Term "foo" [Hole 1,        Term "zonk" [], Hole 3])
      (Term "foo" [Term "bar" [], Hole 2,         Term "baz" []])
      []
 --> Just [(3,Term "baz" []),(2,Term "zonk" []),(1,Term "bar" [])]

-- These should not unify:
unify (Term "foo" []) (Term "bar" []) []
 --> Nothing

-}

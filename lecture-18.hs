-- "Why Functional Programming Matters"

-- Haskell

{- This is also a comment
   Which extends for three lines.
   This {- Nests -} properly -}

-- infix syntactic trick

-- f x is function call; parens for grouping

-- lazy

-- Algebraic data types

quadPlus x y = x + x + x + x + y

x ++++ y = x + x + x + x + y

drop1 :: a -> b -> b
drop1 x y = y

neverStop n = neverStop (n+1)

fact1 n = if (n==0) then 1 else n*fact1 (n-1)

fact2 0 = 1
fact2 n = n * fact2 (n-1)

elem3 (a:b:c:ds) = c

[] +++ ys = ys
(x:xs) +++ ys = x:(xs+++ys)

-- Theorem:
--  (as +++ bs) +++ cs == as +++ (bs +++ cs)
-- Proof:
--   Induction (on length of lists)
--   Case analysis (on whether they're empty)
-- For each case:
--   (as +++ bs) +++ cs
--   = ...
--   = ...
--   = as +++ (bs +++ cs)

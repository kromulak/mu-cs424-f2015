-- "Why Functional Programming Matters" (RECOMMENDED READING)

-- Haskell

{- This is also a comment
   Which extends for three lines.
   This {- Nests -} properly -}
   
{- Unlike Scheme, Haskell has index notation.
   Haskell programs are compiled using the command "ghc" (Grand/Glasgow Haskell Compiler) and interpreted using "ghci". -}
   
-- This concatencates too strings together:   
(++) foo bar

-- infix syntactic trick

-- f x is function call; parens for grouping

-- lazy (if we input "(mod 1 0), 8" into drop1 it won't calculate "mod 1 0")

-- Algebraic data types

-- Has pattern matching

-- "head" and "tail" act like "car" and "cdr" from Scheme

-- 1:(2:[]) = [1,2]

quadPlus x y = x + x + x + x + y

x ++++ y = x + x + x + x + y

-- drop1 :: a -> a -> a -- if you try to enter two parameters of different types you'll get an error
drop1 :: a -> b -> b
drop1 x y = y

neverStop n = neverStop (n+1)

fact1 n = if (n==0) then 1 else n*fact(n-1)

fact2 0 = 1
fact2 n = n * fact2 (n-1)
-- :t fact2
-- fact2 :: (Num a, Eq a) => a -> a
elem3 (a:b:c:ds) = c -- if <3 elements, then you get an error telling you've inputted a non-exhaustive pattern

[] +++ ys = ys
(x:xs) +++ ys = x:(xs+++ys)

-- Theorem:
--  (as +++ bs) +++ cs == as +++ (bs +++ cs)
-- Proof:
--	 Induction (on length of lists)
--	 Case analysis (on whether they're empty)
--	 For each case:
--   (as +++ bs) +++ cs
--	 = ...
--	 = ...
--	 = as +++ (bs +++ cs)
{- We can load Haskell files in the terminal using the command ":l [FILE NAME]"
   We can either call
>	quadPlus x y OR
>	x 'quadPlus' y
   If we call ":t [FUNCTION NAME]" we get the input type(s) and the return types.-}
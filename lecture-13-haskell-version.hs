{-# LANGUAGE UnicodeSyntax #-}

module Lambda where

import Prelude hiding ((.), succ, fst, snd)

-- Lambda calculus - Modelling the Natural Numbers

-- Scheme is based on lambda calculus. There are some differences,
-- such as when there isn't one variable. Lambda calculus can only
-- have one variable, while Scheme can have more than that or even
-- none. In lambda calculus there's no concept of definitions or
-- recursion, just abbreviation.

-- First two: equivalent up to α-renaming, second two are not.
-- a (λ x . x)
-- a (λ y . y)
-- b (λ y . y)

-- Church-encoded natural numbers:

--  zero  = λ f . λ x . x           = λ f x . x
--  one   = λ f . λ x . f x         = λ f x . f x
--  two   = λ f . λ x . f (f x)     = λ f x . f (f x)
--  three = λ f . λ x . f (f (f x)) = λ f x . f (f (f x))

-- Increment a number by one:
--  inc = λ n . λ f x . f (n f x)
--  inc = λ n . λ f x . n f (f x)  [should be equivalent]

-- Want to show:
--  inc zero ↝ one
--  (λ n . λ f . λ x . f (n f x)) (λ f . λ x . x)
--   ↝ [n↦(λ f . λ x . x)](λ f . λ x . f (n f x))
--   = λ f . λ x . f (((λ f . λ x . x) f) x)
--   ↝ λ f . λ x . f ([f↦f](λ x . x) x)
--   = λ f . λ x . f ((λ x . x) x)
--   ↝ λ f . λ x . f ([x↦x]x)
--   = λ f . λ x . f x
--  which is the same as one.  QED

-- Add two numbers:
--  add = λ n m . n inc m
--  add = λ n m . m inc n
--  add = λ n m . λ f x . m f (n f x)

--  compose = λ f g . λ x . f (g x)

--  add = λ n m . λ f . compose (n f) (m f)

-- Multiply two numbers:
--  mul = λ n m . λ f . n (m f)

-- Exponentiation:
--  expon = λ n m . m (mul n) one

zero :: a -> b -> b
zero  = \f x -> x

one :: (a -> b) -> a -> b
one   = \f x -> f x

two :: (a -> a) -> a -> a
two   = \f x -> f (f (x))

three :: (a -> a) -> a -> a
three = \f x -> f (f (f (x)))

-- "succ" named "inc" in lecture12 notes
-- succ = \n . \f x . f (n f x)
succ = \n -> \f x -> f (n f x)

add = \n -> \m -> (n succ) m

multiply = \n m f -> n (m f)

exponential = \n -> \m -> m (multiply n) one

churchToInt = \n -> n (+ 1) 0

churchToBool = \b -> (b True) False

-- Representing Booleans
brue :: a -> b -> a
true = \x -> \y -> x

false :: a -> b -> b
false = \x -> \y -> y

-- encoding pairs in Lambda Calculus is similar to cons in scheme
pair = \x -> \y -> \b -> (b x) y
fst = \p -> p true
snd = \p -> p false

-- composition of functions
infixr 9 .                 -- setting operator precedence
f . g = \x -> f (g (x))
compose = (.)


-- Combinators
i = \x -> x
k = \x y -> x
s = \x y z -> x y (y z)

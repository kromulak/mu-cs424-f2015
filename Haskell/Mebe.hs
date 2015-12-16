module Mebe where

import Control.Monad 

{- | Haskell's alternative for null. Null in most languages often lead to
 - NullPointerExceptions and Seg Faults, Haskell's 'Maybe' a type is a type
 - safe alternative to null. Sny function using a 'Maybe' must have 'Maybe' in
 - its type definition. For example; `mebeRecip :: Double -> Maybe Double`. The
 - advantage to this is any function that has a chance of returning 'Nothing'
 - can be seen by its Type.
 -
 - In this module Barak has comically called it a 'Mebe'
-}
data Mebe a = Nada | Gotta a
            deriving (Eq, Show)

instance Functor Mebe where
  fmap = mebeMap

instance Applicative Mebe where
  pure  = Gotta
  Nada <*> _ = Nada
  Gotta f <*> Nada = Nada
  Gotta f <*> (Gotta x) = Gotta (f x)

instance Monad Mebe where
  return = Gotta
  Nada >>= _ = Nada
  (Gotta x) >>= f = f x

-- | Safely computes the reciprocal of a number, returning 'Nada' if division
-- is impossible.
mebeRecip :: Double -> Mebe Double -- recip is reciprocal, i.e., recip = (1/)
mebeRecip 0 = Nada
mebeRecip x = Gotta (1/x)

-- | Safely computes the square root of a function, returning 'Nada' if x < 0.
mebeSqrt :: Double -> Mebe Double
mebeSqrt x | x >= 0 = Gotta (sqrt x)
mebeSqrt x | x < 0  = Nada

-- Want to safely (i.e., propagating "failure") calculate
--  s1pr x = sqrt (1 + recip x)

-- wow this is awful
s1pr1 x =
  let x1 = mebeRecip x          -- recip x
      x2 =                      -- 1 + recip x
        -- case statement - I guess its like a switch statement but a little
        case x1 of       -- more pure
          Nada -> Nada
          Gotta x1_ -> Gotta (1 + x1_)
      x3 =                      -- sqrt (1 + recip x)
        case x2 of
          Nada -> Nada
          Gotta x2_ -> mebeSqrt x2_
  in
   x3

-- | Maps a function over a Mebe
mebeMap :: (a -> b) -> Mebe a -> Mebe b
mebeMap f Nada = Nada
mebeMap f (Gotta x) = Gotta (f x)

-- still pretty awful
s1pr2 x =
  let x1 = mebeRecip x          -- recip x
      x2 = mebeMap (1+) x1      -- 1 + recip x
      x3 =                      -- sqrt (1 + recip x)
        case x2 of
          Nada -> Nada
          Gotta x2_ -> mebeSqrt x2_
  in
   x3

mebeChain :: Mebe a -> (a -> Mebe b) -> Mebe b
mebeChain Nada _ = Nada
mebeChain (Gotta x) f = f x

s1pr3 x =
  let x1 = mebeRecip x          -- recip x
      x2 = mebeMap (1+) x1      -- 1 + recip x
      x3 = mebeChain x2 mebeSqrt -- sqrt (1 + recip x)
  in
   x3

-- Now we're getting somewhere
s1pr4 x = mebeChain (mebeMap (1+) (mebeRecip x)) mebeSqrt

-- Ok now we have it! The '.' character here is function composition. Function
-- composition is where we compose two functions together to create one. It
-- allows for very readable code; as below can be read as "The square-root of 1
-- plus the reciprocal". I had to use the 'Right-to-left Kleisli composition of
-- monads' operator to compose two functions of type (a -> Mebe b).
-- https://hackage.haskell.org/package/base-4.8.1.0/docs/Control-Monad.html#v:-60--61--60-
--
-- function composition is defined as:
--
-- f . g = \x -> f(g(x))
--
-- But wait, where did the variable go? This is a feature of Haskell called
-- currying. We have defined our function as the composition of other
-- functions, so Haskell can 
--
s1pr5 = mebeSqrt <=< mebeMap (+1) . mebeRecip

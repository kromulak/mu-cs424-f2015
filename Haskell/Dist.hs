--------------------------------------------------------------------------------
{- |
Module      :  Dist
Description :  Represent a discrete probability distribution.

Maintainer  :  barak@nuim.ie
Stability   :  Stable
Portability :  Portable

Represent a discrete probability distribution. Probabilities are nonnegative
and must sum to one.

Sample Haddock documentation, see https://www.haskell.org/haddock/doc/html/ch03s03.html

-}
--------------------------------------------------------------------------------
module Dist (Dist (Dist), checkProper, normalize) -- Dist(Dist) exports both type and constructor
       where

{- Alternatively we could have used just:
 -
 - `module Dist where`
 -
 - but this would export every function, so instead we specify the functions in
 - brackets as above.
-}

import Control.Applicative

-- ASIDE, HASKELL CONVENTIONS:
-- Regular Variables -> Lower Case
-- Constructors / Function Names -> Upper Case

-- | Represent a discrete probability distribution. Probabilities are
--   nonnegative and must sum to one. Probability is over a list of finite
--   objects, contains a list of objects + prob of each value.

data Dist a = Dist [(a, Double)]
            deriving (Eq, Show)

-- We use the "a" above to parametrise the object. We originally had this set
-- to char and it's functions only worked on chars. Now works on any data type.
-- Lists are syntactic sugar for parametrised types.

-- the `deriving` keyword automatically creates instances for the classes
-- eclosed in parenthesis. Only some classes can be derived, in this case we
-- have the 'Eq' and 'Show' classes. 'Eq' allows us to compare 'Dist' for
-- equality (i.e. the '(==)' and '(/=)' operators.)

-- Giving 'Dist' an instance for Functor, Applicative and Monad, based on the
-- types of the functions defined in this module.

{- | The 'Functor' class is used for types that can be mapped over.
Instances of 'Functor' should satisfy the following laws:

> fmap id  ==  id
> fmap (f . g)  ==  fmap f . fmap g

The instances of 'Functor' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO'
satisfy these laws.
-}
instance Functor Dist where
  -- | Takes some function and a probability distribution and maps f onto Dist.
  fmap f (Dist cProbPairs) = Dist (map (\(c,p)->(f c,p)) cProbPairs)

-- | A functor with application, providing operations to
--
-- * embed pure expressions ('pure'), and
--
-- * sequence computations and combine their results ('<*>').
instance Applicative Dist where
  pure = return
  pf <*> px = pf >>= (\f -> px >>= (pure . f))


-- | Defines 'return' and '(>>=)' for the 'Dist' Type.
--   'return' takes an ordinary value 'x' and returns a Ditribution with one
--   element, (x, 1); meaning that there is a 100% chance to get an x from this
--   distribution.
--
--   >>> (>>=) :: Monad m => m a -> (a -> m b) -> m b
--
--   '(>>=)' is an infix operator, on the left it is expecting a 'Monad' on the
--   left and a `function :: a -> m b` on the right.
--
--   @
--    Dist*> let dd = Dist [(a,0.25),(b,0.5),(c,0.75),(d,1.0)]
--    Dist*> >dd >>= return . (+1)
--    Dist [(a + 1,0.25),(b + 1,0.5),(c + 1,0.75),(d + 1,1.0)]
--   @
instance Monad Dist where
  return x = Dist [(x,1)]

  Dist xps >>= f = Dist $ concatMap g xps
    where
      g (x,p) = scale p (f x)
      -- | Scales up/down the distribution, returns list (since not proper
      --   distribution)
      scale :: Double -> Dist a -> [(a,Double)]
      scale s (Dist yps) = map (\(y,p) -> (y,s*p)) yps

-- | Checks if the probabilities in a distribution sum to 1.
checkProper :: Dist a -> Bool
checkProper (Dist cProbPairs)
  = sum (map snd cProbPairs) ~= 1
    && all (\(_,p) -> 0<=p && p<=1) cProbPairs

-- | About equals function to account for floating point errors
(~=) :: Double -> Double -> Bool
x ~= y = abs (x-y) < 1e-6

-- | Scales the probabilities to sum to one, in case they've drifted.
--   (If floating point were exact this would be unnecessary.)
normalize :: Dist a -> Dist a
normalize (Dist xps) = Dist [(x,p/z) | (x,p) <- xps] where z = sum (map snd xps)

-- Creating a Dist in console: "let d = Dist [('a', 0.5), ('b', 0.4), ('c', 0.1)]
-- "checkProper d" => True
-- "fmap (const '2') d" => checkProper will still return true, prob Dist not changed

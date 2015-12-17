{- Open doc/index.html in a web browser -}

module Monads where

import Prelude hiding (Functor (..), Applicative (..), Monad (..), Maybe (..))

{- | The 'Functor' class is used for types that can be mapped over.
Instances of 'Functor' should satisfy the following laws:

> fmap id  ==  id
> fmap (f . g)  ==  fmap f . fmap g

The instances of 'Functor' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO'
satisfy these laws.
-}

class  Functor f  where
    fmap        :: (a -> b) -> f a -> f b

-- | A functor with application, providing operations to
--
-- * embed pure expressions ('pure'), and
--
-- * sequence computations and combine their results ('<*>').
--
-- A minimal complete definition must include implementations of these
-- functions satisfying the following laws:
--
-- [/identity/]
--
--      @'pure' 'id' '<*>' v = v@
--
-- [/composition/]
--
--      @'pure' (.) '<*>' u '<*>' v '<*>' w = u '<*>' (v '<*>' w)@
--
-- [/homomorphism/]
--
--      @'pure' f '<*>' 'pure' x = 'pure' (f x)@
--
-- [/interchange/]
--
--      @u '<*>' 'pure' y = 'pure' ('$' y) '<*>' u@
--
-- As a consequence of these laws, the 'Functor' instance for @f@ will satisfy
--
--   * @'fmap' f x = 'pure' f '<*>' x@
--
-- If @f@ is also a 'Monad', it should satisfy
--
--   * @'pure' = 'return'@
--
--   * @('<*>') = 'ap'@
--
-- (which implies that 'pure' and '<*>' satisfy the applicative functor laws).

class Functor f => Applicative f where
    -- | Lift a value.
    pure :: a -> f a

    -- | Sequential application.
    (<*>) :: f (a -> b) -> f a -> f b

{- | The 'Monad' class defines the basic operations over a /monad/,
a concept from a branch of mathematics known as /category theory/.
From the perspective of a Haskell programmer, however, it is best to
think of a monad as an /abstract datatype/ of actions.
Haskell's @do@ expressions provide a convenient syntax for writing
monadic expressions.

Instances of 'Monad' should satisfy the following laws:

* @'return' a '>>=' k  =  k a@
* @m '>>=' 'return'  =  m@
* @m '>>=' (\x -> k x '>>=' h)  =  (m '>>=' k) '>>=' h@

Furthermore, the 'Monad' and 'Applicative' operations should relate as follows:

* @'pure' = 'return'@
* @('<*>') = 'ap'@

The above laws imply:

* @'fmap' f xs  =  xs '>>=' 'return' . f@
* @('>>') = ('*>')@

and that 'pure' and ('<*>') satisfy the applicative functor laws.

The instances of 'Monad' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO'
defined in the "Prelude" satisfy these laws.
-}
class Applicative m => Monad m where
    -- | Sequentially compose two actions, passing any value produced
    -- by the first as an argument to the second.
    (>>=)       :: m a -> (a -> m b) -> m b

    -- | Inject a value into the monadic type.
    return      :: a -> m a
    return      = pure


-- Example using the Maybe Type.

-- Take a look at Hackage: Data.Maybe
-- https://hackage.haskell.org/package/base-4.8.1.0/docs/Data-Maybe.html

-- | The 'Maybe' type encapsulates an optional value.  A value of type
-- @'Maybe' a@ either contains a value of type @a@ (represented as @'Just' a@),
-- or it is empty (represented as 'Nothing').  Using 'Maybe' is a good way to
-- deal with errors or exceptional cases without resorting to drastic
-- measures such as 'error'.
--
-- The 'Maybe' type is also a monad.  It is a simple kind of error
-- monad, where all errors are represented by 'Nothing'.  
data Maybe a = Nothing
             | Just a
             deriving (Eq, Show, Ord, Read)

instance Functor Maybe where
  fmap f Nothing = Nothing
  fmap f (Just x) = Just (f x)

instance Applicative Maybe where
  pure  = Just
  Nothing <*> _ = Nothing  
  Just f  <*> Nothing = Nothing
  Just f  <*> (Just x) = Just (f x)

instance Monad Maybe where
  return = Just
  Nothing  >>= _ = Nothing
  (Just x) >>= f = f x

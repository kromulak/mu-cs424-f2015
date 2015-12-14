
module Mebe ()
       where

data Mebe a = Nada | Gotta a
            deriving (Eq, Show)

mebeRecip :: Double -> Mebe Double -- recip is reciprocal, i.e., recip = (1/)
mebeRecip 0 = Nada
mebeRecip x = Gotta (1/x)

mebeSqrt :: Double -> Mebe Double

mebeSqrt x | x >= 0 = Gotta (sqrt x)
mebeSqrt x | x < 0  = Nada


-- Want to safely (i.e., propagating "failure") calculate
--  s1pr x = sqrt (1 + recip x)

s1pr1 x = 
  let x1 = mebeRecip x          -- recip x
      x2 =                      -- 1 + recip x
        case x1 of
          Nada -> Nada
          Gotta x1_ -> Gotta (1 + x1_)
      x3 =                      -- sqrt (1 + recip x)
        case x2 of
          Nada -> Nada
          Gotta x2_ -> mebeSqrt x2_
  in
   x3

mebeMap :: (a -> b) -> Mebe a -> Mebe b
mebeMap f Nada = Nada
mebeMap f (Gotta x) = Gotta (f x)

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

s1pr4 x = mebeChain (mebeMap (1+) (mebeRecip x)) mebeSqrt

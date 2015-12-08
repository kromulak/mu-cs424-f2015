-- Represent a discrete probability distribution
-- Probabilities are non-negative and must sum to one.

module Dist (Dist, deltaProb, mapDistDist, cxheckProper,
			 mapDist, dd, scaleDist, dietoDistChar)
	   where

data Dist = Dist [(Char,Double)]
			deriving (Eq, Show)
			
CheckProper :: Dist -> Bool
CheckProper (Dist cProbPairs)
	= sum (map snd cProbPairs) ~= 1
	&& all (\(_,p) -> 0<=p && p<=1) cProbPairs
	
(~=) :: Double -> Double -> Bool	
x ~= y = abs(x-y)<1e-6

mapDist :: (Char -> Char) -> Dist -> Dist
mapDist (Dist cProbPairs) = Dist (map xform cProbPairs)
	where xform (c,p) = (f c,p)
	
-- P(Dice)
-- P(Coin | Dice)
-- together induce P(Coin) = sum_{Dice} P(Coin | Dice) P(Dice)

mapDistDist :: Dist a -> (a -> Dist b) -> Dist b
mapDistDist (Dist xps) f = Dist (concat (map g xps))
	where g (x,p) = scaleDist p (f x)
	
scaleDist :: Double -> Dist a -> [(a,Double)]
scaleDist s (Dist xps) = map (\(x,p) -> (x,s*p)) xps

-- Distribution over 4-sided die
dd = Dist [(0,1/4),(1,1/4),(2,1/4),(3,1/4)]

deltaProb :: a -> Dist a
deltaProb x = Dist [(x,1)]

dieToDistChar :: Integer -> Dist Char
dieToDistChar 0 = deltaProb 'a'
dieToDistChar 1 = Dist [('c',1/2),('d',1/2)]
dieToDistChar 2 = deltaProb 'b'
dieToDistChar 3 = Dist [('b',1/3),('c',1/3)]
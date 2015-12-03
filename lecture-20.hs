-- Algebraic Data Types

-- equivalent to Java or C or C++ "enum"
data Colour = Red | Blue | Green | Yellow | Orange
            deriving (Eq, Show)

raCanSee :: Colour -> Bool
raCanSee Red = False
raCanSee _ = True

-- equivalent to C "struct"
data Point3D = Point3D Double Double Double
            deriving (Eq, Show)

getX (Point3D x y z) = x
getY (Point3D x y z) = y
getZ (Point3D x y z) = z

-- combines C "struct" nested inside "union"
data Shape = Line Point3D Point3D | Triangle Point3D Point3D Point3D
            deriving (Eq, Show)

-- find leftmost x coord value
leftMost :: Shape -> Double
leftMost (Line (Point3D x0 _ _) (Point3D x1 _ _)) = min x0 x1
leftMost (Triangle (Point3D x0 _ _) (Point3D x1 _ _) (Point3D x2 _ _))
  = minimum [x0,x1,x2]

-- Represent a discrete probability distribution.
-- Probabilities are nonnegative and must sum to one.
data Dist a = Dist [(a, Double)]
            deriving (Eq, Show)

checkProper :: Dist a -> Bool
checkProper (Dist cProbPairs)
  = sum (map snd cProbPairs) ~= 1
    && all (\(_,p) -> 0<=p && p<=1) cProbPairs

(~=) :: Double -> Double -> Bool
x ~= y = abs(x-y)<1e-6

mapDist :: (a -> b) -> Dist a -> Dist b
mapDist f (Dist cProbPairs) = Dist (map xform cProbPairs)
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
dieToDistChar 3 = Dist [('b',1/3),('c',2/3)]

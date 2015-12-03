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
data Dist = Dist [(Char,Double)]
            deriving (Eq, Show)

checkProper :: Dist -> Bool
checkProper (Dist cProbPairs)
  = sum (map snd cProbPairs) ~= 1
    && all (\(_,p) -> 0<=p && p<=1) cProbPairs

(~=) :: Double -> Double -> Bool
x ~= y = abs(x-y)<1e-6

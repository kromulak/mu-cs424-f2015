------------------------- Algebraic Data Types -> Leading up to monads-------------------------

import Control.Applicative

-- equivalent to Java or C or C++ "enum"
-- Before we added the "deriving (Eq, Show), the colour objects
-- couldn't be printed, only pattern matched
data Colour = Red | Blue | Green | Yellow | Orange
            deriving (Eq, Show)

-- This allows Colour to be a specific data type
-- :t Red :: Colour
-- :t [Red, Green, Blue] :: [Colour] (list of colours)

-- Ray is partially colour-blind and can't see Red, all other colours he can see
-- The "_" is a don't care value, any other element in data type "Colour" returns True
raCantSee :: Colour -> Bool
raCantSee Red = False
raCantSee _ = True

-- equivalent to C "struct"
data Point3D = Point3D Double Double Double
            deriving (Eq, Show)

-- :t Point3D :: D -> D -> D -> Point3D (takes 3 doubles, returns a 3D point)

-- Can create a 3D point at console with: "Point3D 0.1 0.2 0.3" or similar

-- Return single element functions
getX (Point3D x y z) = x
getY (Point3D x y z) = y
getZ (Point3D x y z) = z

-- combines C "struct" nested inside "union"
-- Allows us to specify multiple types of shapes
data Shape = Line Point3D Point3D | Triangle Point3D Point3D Point3D
            deriving (Eq, Show)

-- find leftmost X Coordinate Value
-- We use don't care values to show we only care about the min of the x's
-- In the triangle, we need to use the minimum function as "min" only takes 2 arguments
leftMost :: Shape -> Double
leftMost (Line (Point3D x0 _ _) (Point3D x1 _ _)) = min x0 x1
leftMost (Triangle (Point3D x0 _ _) (Point3D x1 _ _) (Point3D x2 _ _))
  = minimum [x0,x1,x2]

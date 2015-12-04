------------------------- Algebraic Data Types -> Leading up to monads-------------------------

-- equivalent to Java or C or C++ "enum"
-- Before we added the "deriving (Eq, Show), the colour objects 
-- couldn't be printed, only pattern matched
data Colour = Red | Blue | Green | Yellow | Orange
            deriving (Eq, Show)
            
-- This allows Colour to be a specific data type
-- :t Red :: Colour
-- :t [Red, Green, Blue] :: [Colour] (list of colours)

-- Ray is partially colourblind and can't see Red, all other colours he can see
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
  
-- ASIDE, HASKELL CONVENTIONS:
-- Regular Variables -> Lower Case
-- Constructors / Function Names -> Upper Case

-------------------------Probability Section---------------------------

-- Represent a discrete probability distribution.
-- Probabilities are nonnegative and must sum to one.
-- Probability is over a list of finite objects, contains a list of objects + prob of each value.
data Dist a = Dist [(a, Double)]
            deriving (Eq, Show)
            
-- We use the "a" above to parametrise the object. We originally had this set to char and it's
-- functions only worked on chars. Now works on any data type. Lists are syntactic sugar for parametrised types.

--Ensures the probability distribution sums to 1
-- Again parametrised, originally didn't contain a in type declaration
-- all section ensures all values are between 0 and 1, doesnt care about parameter 
checkProper :: Dist a -> Bool
checkProper (Dist cProbPairs)
  = sum (map snd cProbPairs) ~= 1
    && all (\(_,p) -> 0<=p && p<=1) cProbPairs

-- About equals function to account for floating point errors
(~=) :: Double -> Double -> Bool
x ~= y = abs (x-y) < 1e-6

-- Non parametrised version:  mapDist :: (char -> char) -> Dist -> Dist
-- Takes some function and a probability distribution and maps f onto Dist.
mapDist :: (a -> b) -> Dist a -> Dist b
mapDist f (Dist cProbPairs) = Dist (map xform cProbPairs)
  where xform (c,p) = (f c,p)

-- Creating a Dist in console: "let d = Dist [('a', 0.5), ('b', 0.4), ('c', 0.1)]
-- "checkProper d" => True
-- "mapDist (const '2') d" => checkProper will still return true, prob Dist not changed

------------------------Probability over different distributions of coin tosses--------------------

-- P(Dice)
-- P(Coin | Dice)
-- together induce P(Coin) = sum_{Dice} P(Coin | Dice) P(Dice)

-- Concat will map a list of lists together
-- xps = pairs of x's and probabilities
-- p = probability of x
-- fx = probability of b's
mapDistDist :: Dist a -> (a -> Dist b) -> Dist b
mapDistDist (Dist xps) f = Dist (concat (map g xps))
  where g (x,p) = scaleDist p (f x)

-- Scales up the distribution
scaleDist :: Double -> Dist a -> [(a,Double)]
scaleDist s (Dist xps) = map (\(x,p) -> (x,s*p)) xps

-- Distribution over fair 4-sided die
let dd = Dist [(0,1/4),(1,1/4),(2,1/4),(3,1/4)]

-- checkProper dd => True

-- Take an a and confirm it is definitely an a using a Dist
deltaProb :: a -> Dist a
deltaProb x = Dist [(x,1)]

-- Maps the probability across to a char distribution
dieToDistChar :: Integer -> Dist Char
dieToDistChar 0 = deltaProb 'a'
dieToDistChar 1 = Dist [('c',1/2),('d',1/2)]
dieToDistChar 2 = deltaProb 'b'
dieToDistChar 3 = Dist [('b',1/3),('c',2/3)]

-- Console: mapDistDist dd dieToDistChar => Gives probability output of dd

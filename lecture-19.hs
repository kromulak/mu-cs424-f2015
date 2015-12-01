import Data.Function			-- gives all of the definitions in Data.Function

(+++) :: [a] -> [a] -> [a]

[] +++ ys = ys					-- Line 1
(x:xs) +++ ys = x:(xs+++ys)		-- Line 2

{- 	
Theorem:
	(+++) is associative
	i.e.,
	(as +++ bs) +++ cs == as +++ (bs +++ cs)

Proof:
	Strategy: Induction on length of first argument
		Call that length n
	  
Case n=0:
	Need to show:
	([] +++ bs) ++ cs = [] ++ (bs ++ cs)
	
	([] +++ bs) ++ cs = bs ++ cs 	(by Line 1 on: [] ++ bs)
	[] ++ (bs ++ cs) = bs ++ cs		(by Line 1)
	
Case n>=1:
	Need to show:
		((a:as) +++ bs) +++ cs == (a:as) +++ (bs +++ cs)
		
		((a:as) +++ bs) +++ cs 
			= (a(as+++bs)) +++ cs	(by Line 2)
			= a:((as+bs)++cs)		(by Line 2)
		
		(a:as) +++ (bs +++ cs)
			= a:(as+++(bs+++cs))	(by Line 2)
			= a:((as+++bs)+++cs)	(by induction hypothesis)

QED			
-}

fib1 :: Int -> Integer

fib1 0 = 1
fib1 1 = 1
fib1 n = fib1(n-1) + fib1(n-2)	-- Lambda calculus doesn't allow for recursion unless you've fully defined the function beforehand

fibY :: (Int -> Integer) -> (Int -> Integer)

fibY fib 0 = 1
fibY fib 1 = 1
fibY fib n = fib(n-1) + fib(n-2)

fib2 = fix fibY					-- fix = fixedpoint combinator, contained in the Data.Function set

-- fib3 = memoFix fibY

fib4 0 = 1
fib4 n = fibAux n 1 1 (fib4 0)

-- fibAux n i fib_i fib_i_minus_1 = fib n, i<=n
fibAux n i fib_i fib_i_minus_1 =
	if i==n 
	then fib_i 
	else fibAux n (i+1) (fib_i+fib_i_minus_1) fib_i
	
-- fibs is a list of the Fibonacci numbers

{-
	fibs = [1,1,2,3,5,8,13,21,34,55,89,...]
drop 1 fibs = [1,2,3,5,8,13,21,34,55,89,...]
			  -----------------------------
drop 2 fibs = [2,3,5,8,13,21,34,55,89,...]

so

drop 2 fis = zipWith (+) fibs (drop 1 fibs)
-}

fibs :: [Integer]
fibs = 1:1:zipWith (+) fibs (drop 1 fibs)		-- this wouldn't work if Haskell wasn't lazy

fib5 :: Int -> Integer
fib5 n = fibs !! n								-- !! = indexing operator

-- Rewrite in Point-Free Style
fib6 :: Int -> Integer
fib6 = (fibs !!)

{- Algebraic Data Types
	These are a generalisation of the likes of enums. -}
import Data.Ord
import Data.List

collatz 1 = [1]
collatz x
    | even x = x : collatz (x `div` 2)
    | odd x  = x : collatz ((x * 3) + 1)

-- main = readLn >>= print . maximumBy (comparing (length . collatz)) . enumFromTo 0
main = do
  n <- readLn 
  print $ maximumBy (comparing (length . collatz)) [1..n]

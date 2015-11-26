import Data.Char

shift n = map (shift' n)

shift' n c
  | isUpper c = chr . (+ 65) . (`mod` 26) . (+n) . subtract 65 $ ord c
  | isLower c = chr . (+ 97) . (`mod` 26) . (+n) . subtract 97 $ ord c
  | otherwise = c

main = do
  n <- readLn
  getLine >>= putStrLn . shift n

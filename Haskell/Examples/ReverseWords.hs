reverseWords :: String -> String
reverseWords = unwords . map reverse . words

main = getContents >>= mapM_ print . map reverseWords . lines

-- Note Haskell/* subdir

{-

putChar :: Char -> World -> (World, ())
getChar ::         World -> (World, Char)

data IO a = World -> (World, a)

putChar :: Char -> IO ()
getChar ::         IO Char

ioChain :: IO a -> (a -> IO b) -> IO b

semicolon :: IO a -> IO b -> IO b
semicolon ioa iob = ioChain ioa (const iob)

return a :: IO a
  (does nothing, yields arg)

-}

-- ioChain = (>>=)
-- semicolon = (>>)

putString :: [Char] -> IO ()
putString cs = concatWithSemi (map putChar cs)

concatWithSemi :: [IO ()] -> IO ()
concatWithSemi [] = return ()
concatWithSemi [x] = x
concatWithSemi (x:xs) = x >> concatWithSemi xs

--------------------------

-- These are "Monads":

--  Mebe a
--  IO a
--  Dist a

-- *Main> :t return
-- return :: Monad m => a -> m a

-- "bind",

-- *Main> :t (>>=)
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b

-- *Main> :t putString 
-- putString :: [Char] -> IO ()
-- *Main> getChar >>= \x -> putString [x,x,x,x]
-- zzzzz

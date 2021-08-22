module CollatzConjecture (collatz) where

addOne :: Maybe Integer -> Maybe Integer
addOne n = do
            v <- n
            return (v + 1)

collatz :: Integer -> Maybe Integer
collatz n | n <= 0 = Nothing
          | n == 1 = Just 0
          | even n = addOne (collatz (div n 2) )
          | otherwise = addOne (collatz (3*n+1) )

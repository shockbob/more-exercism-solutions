module Squares (difference, squareOfSum, sumOfSquares) where

difference :: Integral a => a -> a
difference n = squareOfSum n - sumOfSquares n 

squareOfSum :: Integral a => a -> a
squareOfSum n = sumToN * sumToN
              where sumToN = (n * (n + 1)) `div`  2 

sumOfSquares :: Integral a => a -> a
sumOfSquares n =  (n *(n +1 )*((n * 2)+ 1)) `div` 6   

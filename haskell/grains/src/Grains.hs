module Grains (square, total) where

square' :: Integer -> Integer
square' n = 2 ^ (n - 1) 

square :: Integer -> Maybe Integer
square n | n <= 0 || n > 64 = Nothing
         | otherwise = Just (square' n) 

total :: Integer
total = sum (map square' [1..64]) 

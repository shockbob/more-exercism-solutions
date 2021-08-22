module SumOfMultiples (sumOfMultiples) where

mymod :: Integer -> Integer -> Integer
mymod _ 0 = -1
mymod m n = mod m n

check :: [Integer] -> Integer -> Bool
check factors m = any (\x ->mymod m x == 0) factors

listAll :: [Integer] -> Integer -> [Integer]
listAll factors limit = filter (check factors)  [1..limit-1]

sumOfMultiples :: [Integer] -> Integer -> Integer
sumOfMultiples factors limit = sum (listAll factors limit) 

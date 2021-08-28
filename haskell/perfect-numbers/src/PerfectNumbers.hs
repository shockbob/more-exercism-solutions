module PerfectNumbers (classify, Classification(..)) where

data Classification = Deficient | Perfect | Abundant deriving (Eq, Show)

aliquot :: Int -> Int
aliquot n = sum (filter (\a -> n `mod` a == 0) [1..n-1])
classify :: Int -> Maybe Classification
classify n | n <= 0 = Nothing
           | ali < n = Just Deficient
           | ali == n = Just Perfect
           | ali > n = Just Abundant
           where ali = aliquot n  

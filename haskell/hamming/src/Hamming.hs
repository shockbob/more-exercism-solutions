module Hamming (distance) where

distance':: String -> String -> Int
distance' _ "" = 0
distance' "" _ = 0
distance' (x:xs) (y:ys) | x /= y = (1 + distance' xs ys )
                        | otherwise = distance' xs ys

distance :: String -> String -> Maybe Int
distance xs ys | length xs /= length ys = Nothing
               | otherwise = Just (distance' xs ys)

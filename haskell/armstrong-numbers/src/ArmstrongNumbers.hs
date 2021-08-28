module ArmstrongNumbers (armstrong) where
import Data.Char (digitToInt)
armstrong' :: String -> Int -> Int -> Int -> Bool
armstrong' "" _ value total = total == value
armstrong' (x:xs) len value total = armstrong' xs len value (total + digitToInt x ^ len)
armstrong :: Int -> Bool
armstrong a = armstrong' str (length str) a 0 
              where str = show a

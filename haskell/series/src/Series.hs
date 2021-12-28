module Series (slices) where
import Data.Char (digitToInt)

slices' :: Int ->  [Int] -> [[Int]]
slices' size xs | length xs < size = []
                    | otherwise = (take size xs) : slices' size (drop 1 xs)
slices :: Int -> String -> [[Int]]
slices size xs | size <= 0 = [[]] 
               | size > length xs = []
               | otherwise = slices' size (map digitToInt xs)

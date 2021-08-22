module Pangram (isPangram) where
import Data.Char
import qualified Data.Set as Set


isPangram' :: String -> Set.Set Char -> Bool
isPangram' "" set = Set.size set == 26 
isPangram' (x:xs) set | (isAscii x) && (isAlpha x) = isPangram' xs (Set.insert (toLower x) set)
                      | otherwise = isPangram' xs set
isPangram :: String -> Bool
isPangram xs = isPangram' xs Set.empty

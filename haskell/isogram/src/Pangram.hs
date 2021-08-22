module Pangram (isPangram) where
import Data.Char
import qualified Data.Set as Set

isPangram' :: String -> Set.Set Char -> Bool
isPangram' "" _ = True
isPangram' (x:xs) set | isAlpha x && Set.member x set = False
                      | otherwise = isPangram' xs (Set.insert x set)
isPangram :: String -> Bool
isPangram "" = False 
isPangram xs = isPangram' xs Set.empty

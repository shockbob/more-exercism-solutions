module Isogram (isIsogram) where

import Data.Char
import qualified Data.Set as Set

isIsogram' :: String -> Set.Set Char -> Bool
isIsogram' "" _ = True
isIsogram' (x:xs) set | isAlpha x && Set.member (toLower x) set = False
                      | otherwise = isIsogram' xs (Set.insert (toLower x) set)
isIsogram :: String -> Bool
isIsogram xs = isIsogram' xs Set.empty

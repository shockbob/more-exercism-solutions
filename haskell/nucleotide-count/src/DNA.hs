module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map(Map,empty,insertWith)
import Data.List(foldr,any)
import Data.Maybe

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)
mapToNuc :: Char -> Maybe Nucleotide
mapToNuc ch |ch=='A' = Just A
            |ch=='G' = Just G
            |ch=='T' = Just T
            |ch=='C' = Just C
            |otherwise = Nothing

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs | any isNothing (map mapToNuc xs) = Left "Bad nucs"
                    | otherwise =  Right (foldr ((\x m -> insertWith (+) (fromJust x) 1 m) . mapToNuc) empty xs )


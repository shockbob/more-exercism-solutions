module Bob (responseFor) where

import Data.Char
trim :: String -> String
trim xs = reverse (dropWhile isSpace (reverse (dropWhile isSpace xs)))
allSpaces :: String -> Bool
allSpaces xs = all isSpace 
hasUppers :: String -> Bool
hasUppers xs = any isUpper 
allUppers :: String -> Bool
allUppers xs = hasUppers xs && (map toUpper xs == xs)
question :: String -> Bool
question xs = last xs == '?'
exclaim :: String -> Bool
exclaim xs = last xs == '!'

responseFor :: String -> String
responseFor xs | allSpaces trimmed = "Fine. Be that way!"
               | allUppers trimmed && question trimmed = "Calm down, I know what I'm doing!"
               | question trimmed = "Sure."
               | allUppers trimmed && exclaim trimmed = "Whoa, chill out!"
               | allUppers trimmed = "Whoa, chill out!"
               | null trimmed = "Fine. Be that way!"
               | otherwise = "Whatever."  
               where 
                   trimmed = trim xs

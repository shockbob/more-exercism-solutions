module ArmstrongNumbers (armstrong) where

armstrong' :: String => Integer -> Integer -> Bool
armstrong' "" value total = total == value
armstrong' (x:xs) len value total = armstrong' xs len value (total + (digitToInt x)^len)
armstrong :: Integral a => a -> Bool
armstrong a = armstrong' str strlen str a 0 
              where str = show a

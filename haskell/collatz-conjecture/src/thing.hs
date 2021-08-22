pangram' :: String -> Set.Set Char -> Bool
pangram' "" set = True
pangram' (x:xs) set | isAlpha x && Set.member x set = False
                    | otherwise = pangram' xs (Set.insert x set)
pangram :: String -> Bool
pangram xs = pangram' xs Set.empty
main :: IO ()

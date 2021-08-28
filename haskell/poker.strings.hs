module Poker (bestHands) where
import Data.Maybe (isNothing,fromJust)
import qualified Data.Map as M (lookup,fromList)
import qualified Data.Text as T (take, drop,Text,splitOn,length,pack)

rankList = [("2",2),("3",3),("4",4),("5",5),("6",6),
                    ("7",7),("8",8),("9",9),("10",10),("J",11),
                    ("Q",12),("K",13),("A",14)]
rankListText = map (\(a,b) -> (T.pack a, b)) rankList
rankMap = M.fromList rankListText

getCards :: T.Text -> [T.Text]
getCards = T.splitOn (T.pack " ") 
getRank :: T.Text -> Integer
getRank s | isNothing result = -1
          | otherwise = fromJust result 
            where result = M.lookup (T.take (T.length s - 1) s) rankMap

getSuit :: T.Text -> T.Text 
getSuit s = T.drop (T.length s - 1) s
bestHands :: [String] -> Maybe [String]
bestHands = error "You need to implement this function!"

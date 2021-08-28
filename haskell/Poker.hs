module Poker (bestHands) where
import Data.Maybe (isNothing,fromJust)
import qualified Data.Map as M (lookup,fromList)
import qualified Data.String as Str 
import qualified Data.Set  as S (Set,size,fromList,member)
import qualified Data.List as L (elem,group,sort)

data Recognizer = Recognizer { recog :: (String -> Bool) }
rankList = [("2",2),("3",3),("4",4),("5",5),("6",6),
                    ("7",7),("8",8),("9",9),("10",10),("J",11),
                    ("Q",12),("K",13),("A",14)]
rankMap = M.fromList rankList

ranks = [14,2,3,4,5,6,7,8,9,10,11,12,13,14]

getRanks' :: [Integer] -> [S.Set Integer]
getRanks' ranks | length ranks < 5 =  []
               | otherwise = (S.fromList (take 5 ranks)) : getRanks' (tail ranks) 

getRanks :: [S.Set Integer]
getRanks = getRanks' ranks

isPair :: String -> Bool
isPair hand = (getPattern hand) == [1,1,1,2]
pairRecognizer = Recognizer { recog = isPair }
isTwoPair :: String -> Bool
isTwoPair hand = (getPattern hand) == [1,2,2]
twoPairRecognizer = Recognizer { recog = isTwoPair }

isTriplet :: String -> Bool
isTriplet hand = (getPattern hand) == [1,1,3]
tripletRecognizer = Recognizer { recog = isTriplet }

isQuad :: String -> Bool
isQuad hand = (getPattern hand) == [1,4]
quadRecognizer = Recognizer { recog = isQuad }

isFullHouse :: String -> Bool
isFullHouse hand = (getPattern hand) == [2,3]
fullHouseRecognizer = Recognizer { recog = isFullHouse }

isStraight :: String -> Bool
isStraight hand = L.elem ranksHand getRanks
                where
                    ranksHand = S.fromList (map getRank (getCards hand))
straightRecognizer = Recognizer { recog = isStraight }

isFlush :: String -> Bool
isFlush hand = S.size suitSet == 1
          where suitSet = S.fromList (map getSuit (getCards hand))
flushRecognizer = Recognizer { recog = isFlush }

isStraightFlush :: String -> Bool
isStraightFlush = (isStraight hand) && (isFlush hand)
straightFlushRecognizer = Recognizer { recog = isStraightFlush }

getPattern :: String -> [Int]
getPattern hand = L.sort (map length (L.group (L.sort (map getRank (getCards hand)))))
getCards :: String -> [String]
getCards = Str.words 
getRank :: String -> Integer
getRank s | isNothing result = -1
          | otherwise = fromJust result 
            where result = M.lookup (take (length s - 1) s) rankMap

getSuit :: String -> String 
getSuit s = drop (length s - 1) s
bestHands :: [String] -> Maybe [String]
bestHands = error "You need to implement this function!"

module Poker
  ( bestHands
  ) where

import qualified Data.List as L (group, head, length, sort, tail)
import qualified Data.Map as M (Map, fromList, lookup)
import Data.Maybe (fromJust, isNothing)
import qualified Data.String as Str (words)

type HandRecognizer = String->Bool
type ScoreCalculator = String->Integer
data Recognizer =
  Recognizer
    { recog :: HandRecognizer 
    , addOn :: Integer
    , scoreCalc :: ScoreCalculator 
    }

convertBase15 :: [Integer] -> Integer -> Integer
convertBase15 x tot
  | null x = tot
  | otherwise = convertBase15 (L.tail x) tot * 15 + L.head x

getSuit :: String -> String
getSuit s = drop (length s - 1) s

rankList :: [(String, Integer)]
rankList = [ ("2", 2) , ("3", 3) , ("4", 4) , ("5", 5) , ("6", 6) , ("7", 7) , ("8", 8) , ("9", 9) , ("10", 10) , ("J", 11) , ("Q", 12) , ("K", 13) , ("A", 14) ]

rankMap :: M.Map String Integer
rankMap = M.fromList rankList

getRank :: String -> Integer
getRank s
  | isNothing result = -1
  | otherwise = fromJust result
  where
    result = M.lookup (take (length s - 1) s) rankMap

straights :: [[Integer]]
straights = [ [2, 3, 4, 5, 14], [2..6], [3..7], [4..8], [5..9], [6..10], [7..11], [8..12], [9..13], [10..14]]

getRanksFromHand :: String -> [Integer]
getRanksFromHand hand = map getRank (getCards hand)

makeMatchers :: String -> [(Int, Integer)]
makeMatchers hand =
  L.sort
    (map
       (\lst -> (L.length lst, L.head lst))
       (L.group (L.sort (getRanksFromHand hand))))

scoreByMax :: ScoreCalculator 
scoreByMax hand = maximum (getRanksFromHand hand)

scoreByStraight :: ScoreCalculator 
scoreByStraight hand
  | (2 `elem` handRanks) && (14 `elem` handRanks) = 5
  | otherwise = maximum handRanks
  where
    handRanks = getRanksFromHand hand

getScoreForHighCard :: ScoreCalculator 
getScoreForHighCard hand = convertBase15 (L.sort (getRanksFromHand hand)) 0

scoreByPattern :: ScoreCalculator
scoreByPattern hand = convertBase15 (map snd (makeMatchers hand)) 0

patternRecognizer :: [Int] -> (String->Bool)
patternRecognizer pattern = (\ hand -> (getPattern hand) == pattern)

isStraight :: HandRecognizer 
isStraight hand = ranksHand `elem` straights
  where
    ranksHand = L.sort (getRanksFromHand hand)

isFlush :: HandRecognizer 
isFlush hand = all (\ s -> head(suits) == s) suits 
  where
    suits = map getSuit (getCards hand)

isStraightFlush :: HandRecognizer 
isStraightFlush hand = isStraight hand && isFlush hand

recognizers :: [Recognizer]
recognizers =
  [ Recognizer {recog = isStraightFlush, addOn = 8, scoreCalc = scoreByStraight}
  , Recognizer {recog = patternRecognizer [1,4], addOn = 7, scoreCalc = scoreByPattern}
  , Recognizer {recog = patternRecognizer [2,3], addOn = 6, scoreCalc = scoreByPattern}
  , Recognizer {recog = isFlush, addOn = 5, scoreCalc = scoreByMax}
  , Recognizer {recog = isStraight, addOn = 4, scoreCalc = scoreByStraight}
  , Recognizer {recog = patternRecognizer [1,1,3], addOn = 3, scoreCalc = scoreByPattern}
  , Recognizer {recog = patternRecognizer [1,2,2], addOn = 2, scoreCalc = scoreByPattern}
  , Recognizer {recog = patternRecognizer [1,1,1,2], addOn = 1, scoreCalc = scoreByPattern}
  , Recognizer {recog = patternRecognizer [1,1,1,1,1], addOn = 0, scoreCalc = getScoreForHighCard}
  ]

getPattern :: String -> [Int]
getPattern hand = L.sort (map length (L.group (L.sort (getRanksFromHand hand))))

getCards :: String -> [String]
getCards = Str.words

handScore :: String -> (Integer, Integer)
handScore hand = (addOn recognizer, scoreCalc recognizer hand)
  where
    recognizer = head (filter (`recog` hand) recognizers)

handScores :: [String] -> [((Integer, Integer), String)]
handScores = map (\hand -> (handScore hand, hand))

bestHands' :: [String] -> [String]
bestHands' hands = bestesthands
  where
    hscores = handScores hands
    maxScore = fst (maximum hscores)
    bestest = filter (\hscore -> maxScore == fst hscore) hscores
    bestesthands = map snd bestest

valid :: String -> Bool
valid hand = suitsOk && ranksOk
  where
    cards = getCards hand
    suitsOk = all ((\suit -> suit `elem` ["C", "H", "D", "S"]) . getSuit) cards
    ranksOk = all ((\rank -> rank `elem` [2 .. 14]) . getRank) cards

bestHands :: [String] -> Maybe [String]
bestHands hands
  | all valid hands = Just (bestHands' hands)
  | otherwise = Nothing 

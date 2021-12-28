{-# LANGUAGE OverloadedStrings #-}

module Forth
  ( ForthError(..)
  , ForthState
  , evalText
  , toList
  , emptyState
  , isTextNumber
  , getWord
  , testWordState
  , fdup
  , fdrop
  , fswap
  , fover
  , fadd
  , fsub
  , predefs
  , fmult
  , fdiv
  , getPredefinedWord
  ) where

import Data.Char
import Data.Either (fromLeft, fromRight, isLeft, isRight)
import Data.List (find)
import Data.Maybe (fromJust, isJust, isNothing)
import Data.Text as T (Text, all, splitOn, toLower)
import Data.Text.Read (decimal, signed)

data ForthError
  = DivisionByZero
  | StackUnderflow
  | InvalidWord
  | UnknownWord Text
  deriving (Show, Eq)

data ForthWord =
  ForthWord
    { name :: Text
    , definition :: [Text]
    , originalWords :: [Text]
    }
  deriving (Show, Eq)

data ForthState =
  ForthState
    { forthWords :: [ForthWord]
    , stack :: [Int]
    }
  deriving (Show, Eq)

testWordState :: ForthState 
testWordState = 
    case newfs of 
        Right(fs) -> fs
        Left(err) -> ForthState{forthWords=[],stack=[]} 
  where
    forthWord = ForthWord {name = "abc", definition = ["dup","dup","dup"], originalWords = ["def","ghi","lmn"]} 
    forthState = ForthState {forthWords = [], stack = []}
    newfs = addWord forthState forthWord
    

getWordsFromState :: Text -> [ForthWord] -> [Text]
getWordsFromState wordName forthWords
  | null foundWords = [wordName]
  | otherwise = definition (head foundWords)
  where
    foundWords = filter (\forthWord -> name forthWord == wordName) forthWords

getWord :: [Text] -> [ForthWord] -> Maybe ForthWord 
getWord code forthWords
  | head code /= ":" = Nothing
  | isTextNumber (code !! 1)  = Nothing 
  | otherwise = Just forthWord
  where
    wordName = code !! 1
    definitionWords = takeWhile (/= ";") (drop 2 code)
    expandedWords = concatMap (`getWordsFromState` forthWords) definitionWords
    forthWord =
      ForthWord
        { name = wordName
        , definition = expandedWords
        , originalWords = definitionWords
        }

dropWord :: ForthWord -> [Text] -> [Text]
dropWord forthWord code = drop (3 + length (originalWords forthWord)) code

last1 :: [Int] -> Int
last1 forthStack = forthStack !! (length forthStack - 2)

last2 :: [Int] -> Int
last2 forthStack = forthStack !! (length forthStack - 3)

type WordFunc = [Int] -> Either ForthError [Int]

fdup :: WordFunc
fdup forthStack
  | null forthStack = Left StackUnderflow
  | otherwise = Right (forthStack ++ [last forthStack])

fdrop :: WordFunc
fdrop forthStack
  | null forthStack = Left StackUnderflow
  | otherwise = Right (take (length forthStack - 1) forthStack)

fswap :: WordFunc
fswap forthStack
  | len < 2 = Left StackUnderflow
  | otherwise =
    Right (take (len - 2) forthStack ++ [last forthStack] ++ [last1 forthStack])
  where
    len = length forthStack

fover :: WordFunc
fover forthStack
  | len < 2 = Left StackUnderflow
  | otherwise = Right (forthStack ++ [last1 forthStack])
  where
    len = length forthStack

fadd :: WordFunc
fadd forthStack
  | len < 2 = Left StackUnderflow
  | otherwise =
    Right (take (len - 2) forthStack ++ [last forthStack + last1 forthStack])
  where
    len = length forthStack

fmult :: WordFunc
fmult forthStack
  | len < 2 = Left StackUnderflow
  | otherwise =
    Right (take (len - 2) forthStack ++ [last forthStack * last1 forthStack])
  where
    len = length forthStack

fsub :: WordFunc
fsub forthStack
  | len < 2 = Left StackUnderflow
  | otherwise =
    Right (take (len - 2) forthStack ++ [last1 forthStack - last forthStack])
  where
    len = length forthStack

fdiv :: WordFunc
fdiv forthStack
  | length forthStack < 2 = Left StackUnderflow
  | last forthStack == 0 = Left DivisionByZero
  | otherwise =
    Right
      (take (len - 2) forthStack ++ [last1 forthStack `div` last forthStack])
  where
    len = length forthStack

predefs :: [(Text, WordFunc)]
predefs =
  [ ("dup", fdup)
  , ("drop", fdrop)
  , ("swap", fswap)
  , ("over", fover)
  , ("+", fadd)
  , ("-", fsub)
  , ("/", fdiv)
  , ("*", fmult)
  ]

getDefinedWord :: Text -> ForthState -> Maybe ForthWord
getDefinedWord forthName forthState = 
  case fword of
    Just (fw) -> Just fw
    otherwise -> Nothing
  where
    fword = find (\x -> (name x) == forthName) (forthWords forthState) 

getPredefinedWord :: Text -> Maybe WordFunc
getPredefinedWord word =
  case predef of
    Just (_, pd) -> Just pd
    otherwise -> Nothing
  where
    predef = find (\x -> (fst x) == word) predefs

isTextNumber :: Text -> Bool
isTextNumber = T.all (\c -> isDigit c || c == '-')

getNumber :: Text -> Maybe Int
getNumber word =
  case signed decimal word of
    Right (num, _) -> Just num
    _ -> Nothing

addWord :: ForthState -> ForthWord -> Either ForthError ForthState
addWord forthState forthWord =
  Right
    ForthState
      { forthWords = [forthWord] ++ words 
      , stack = stack forthState
      }
  where
      words = filter (\fw -> (name fw) /= (name forthWord)) (forthWords forthState)

addNumber :: ForthState -> Int -> Either ForthError ForthState
addNumber forthState num =
  Right
    ForthState
      { forthWords = (forthWords forthState)
      , stack = (stack forthState) ++ [num]
      }

handlePredef :: ForthState -> WordFunc -> Either ForthError ForthState
handlePredef forthState wordFunc =
  case newStack of
    Left (err) -> Left err
    Right (ns) ->
      Right ForthState {forthWords = forthWords forthState, stack = ns}
  where
    newStack = wordFunc (stack forthState)

validWord :: [ForthWord] -> Text -> Bool
validWord forthWords word = word `elem` map name forthWords ||
         word == ":" || word `elem` map fst predefs || isTextNumber word

buildState' ::
     [Text] -> Either ForthError ForthState -> Either ForthError ForthState
buildState' code forthState
  | null code = forthState
  | otherwise =
    case forthState of
      Left err -> Left err
      Right fs -> do
            let isValid = validWord (forthWords fs) (head code)
            (if isValid then 
                (do
                    let number = getNumber (head code)
                    case number of
                       Just num -> buildState' (tail code) (addNumber fs num)
                       _ -> do
                         let newWord = getWord code (forthWords fs)
                         case newWord of
                           Just nw -> buildState' (dropWord nw code) (addWord fs nw)
                           _ -> do
                             let definedWord = getDefinedWord (head code) fs 
                             case definedWord of 
                                 Just defWord  -> buildState' (definition defWord) ++ tail code forthState 
                                 _ -> do
                                    let predefinedWord = getPredefinedWord (head code)
                                    case predefinedWord of
                                         Just pd -> buildState' (tail code) (handlePredef fs pd)
                                         _ -> Left InvalidWord)
         else
            Left (UnknownWord (head code))
            

buildState :: [Text] -> ForthState -> Either ForthError ForthState
buildState code forthState = buildState' code (Right forthState)

emptyState :: ForthState
emptyState = ForthState {forthWords = [], stack = []}

evalText :: Text -> ForthState -> Either ForthError ForthState
evalText text = buildState (T.splitOn " " (T.toLower text))

toList :: ForthState -> [Int]
toList = stack

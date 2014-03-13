module Main where

import Data.Ord (Down(..))
import Data.List (sortBy)
import qualified Data.HashMap.Lazy as H
import Data.Hashable (Hashable)
import qualified Data.ByteString.Lazy as BL
import Data.ByteString.Lazy (ByteString)

type Loc = ByteString
type User = ByteString
type CheckIn = (User, Loc)
type Table a = H.HashMap a Int

main :: IO ()
main = do
    content <- BL.readFile "data/loc.txt"

    let userTable     = accumulate fst (parseCheckIn content)
    let locationTable = accumulate snd (parseCheckIn content)

    putStrLn "top 50 users:\n"
    print (top50 userTable)
    putStrLn "top 50 locations:\n"
    print (top50 locationTable)

-- Parse and make a list of CheckIns
parseCheckIn :: ByteString -> [CheckIn]
parseCheckIn = map (toLoc . splitWords) . filter (not . BL.null) . splitLines 
    where   splitLines = BL.split 0xa
            splitWords = BL.split 0x9
            toLoc xs = (head xs, last xs)

-- Builds a table which counts the occurence of items with first argument being the selector
accumulate :: (Eq a, Hashable a) => (CheckIn -> a) -> [CheckIn] -> Table a
accumulate f = foldr (\a table -> add1 (f a) table) H.empty
    where   add1 key = H.insertWith (\_ n -> n + 1) key 1

top50 :: Ord a => Table a -> [(a, Int)]
top50 = take 50 . sortBy occurence . H.toList 
    where   -- compare occurences first then ID
            occurence (a, x) (b, y) | x == y    = a `compare` b
                                    | otherwise = Down x `compare` Down y

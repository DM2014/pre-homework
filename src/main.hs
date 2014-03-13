module Main where

import Data.Ord (comparing, Down(..))
import Data.List (sortBy)
import qualified Data.HashMap.Lazy as H
import Data.Hashable (Hashable)

type Loc = Int
type User = Int
type CheckIn = (User, Loc)
type Table a = H.HashMap a Int

main = do
    content <- readFile "data/loc.txt"

    let userTable = accumulate fst (parseCheckIn content)
    let locTable = accumulate snd (parseCheckIn content)

    putStrLn "top 50 users:\n"
    print (top50 userTable)
    --putStrLn "top 50 locations:\n"
    --print . take 50 . sortBy (comparing (Down . snd)) . H.toList $ locTable


-- Parse and make a list of CheckIns
parseCheckIn :: String -> [CheckIn]
parseCheckIn = map (toLoc . words) . lines
    where toLoc xs = (read (head xs), read (last xs))

-- Builds a table which counts the occurence of items with first argument being the selector
accumulate :: (Eq a, Hashable a) => (CheckIn -> a) -> [CheckIn] -> Table a
accumulate f = foldr (\a table -> add1 (f a) table) H.empty
    where   add1 key = H.insertWith (\_ n -> n + 1) key 1

top50 :: Ord a => Table a -> [(a, Int)]
top50 = take 50 . sortBy occurence . H.toList 
    where   -- compare occurences first then ID
            occurence (a, x) (b, y) | x == y    = a `compare` b
                                    | otherwise = Down x `compare` Down y

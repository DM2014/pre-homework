module Main where

import              Data.Ord (Down(..))
import              Data.List (sortBy, foldl')
import qualified    Data.HashMap.Strict as H
import              Data.Hashable (Hashable)
import qualified    Data.ByteString.Lazy as BL
import              Data.ByteString.Lazy (ByteString)

type Loc = ByteString
type User = ByteString
type CheckIn = (User, Loc)
type Table a = H.HashMap a Int

main :: IO ()
main = do
    content <- BL.getContents

    let userTable     = accumulate fst (parseCheckIn content)
    --let locationTable = accumulate snd (parseCheckIn content)

    putStrLn "top 50 users:"
    print (top50 userTable)
    --putStrLn "top 50 locations:"
    --print (top50 locationTable)

    --putStrLn "overall mean of users:"
    --print (mean userTable)
    --putStrLn "overall variance of users:"
    --print (variance userTable)

    --putStrLn "overall mean of locations:"
    --print (mean locationTable)
    --putStrLn "overall variance of locations:"
    --print (variance locationTable)


-- Parse and make a list of CheckIns
parseCheckIn :: ByteString -> [CheckIn]
parseCheckIn = map (toLoc . splitWords) . filter (not . BL.null) . splitLines 
    where   splitLines = BL.split 0xa
            splitWords = BL.split 0x9
            toLoc xs = (head xs, last xs)

-- Builds a table which counts the occurence of items with first argument being the selector
accumulate :: (Eq a, Hashable a) => (CheckIn -> a) -> [CheckIn] -> Table a
accumulate f = foldl' (\table a -> add1 (f a) table) H.empty
    where   add1 key = H.insertWith (\_ n -> n + 1) key 1

top50 :: Ord a => Table a -> [(a, Int)]
top50 = take 50 . sortBy occurence . H.toList 
    where   -- compare occurences first then ID
            occurence (a, x) (b, y) | x == y    = a `compare` b
                                    | otherwise = Down x `compare` Down y

mean :: Table a -> Double
mean table = fromIntegral summation / fromIntegral size
    where   summation = H.foldr (+) 0 table
            size = H.size table

variance :: Table a -> Double
variance table = fromIntegral a - b * b
    where   a = H.foldr (\acc n -> acc + n * n) 0 table
            b = mean table
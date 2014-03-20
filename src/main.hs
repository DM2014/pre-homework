{-# LANGUAGE BangPatterns #-}

module Main where

import              PreHomework.Type
import              PreHomework.Parser

import              Data.Ord (Down(..))
import              Data.List (sortBy, foldl')
import qualified    Data.HashMap.Strict as H
import              Data.Hashable (Hashable)
import qualified    Data.ByteString.Lazy as BL
import              Data.ByteString.Lazy (ByteString)

type Table a = H.HashMap a Int

main :: IO ()
main = do
    content <- BL.getContents

    let (userTable, locationTable) = accumulateBoth (parseCheckIn content)

    putStrLn "top 50 users:"
    print (top50 userTable)
    putStrLn "top 50 locations:"
    print (top50 locationTable)

    putStrLn "overall mean of users:"
    print (mean userTable)
    putStrLn "overall variance of users:"
    print (variance userTable)

    putStrLn "overall mean of locations:"
    print (mean locationTable)
    putStrLn "overall variance of locations:"
    print (variance locationTable)


-- Parse and make a list of CheckIns
parseCheckIn :: ByteString -> [CheckIn]
parseCheckIn = map (toLoc . splitWords) . filter (not . BL.null) . splitLines 
    where   splitLines = BL.split 0xa
            splitWords = BL.split 0x9
            --toLoc xs = (head xs, last xs)
            toLoc xs = (parseDemical $ head xs, parseDemical $ last xs)
            --toLoc xs = (read . BLC.unpack $ head xs, read . BLC.unpack $ last xs)

-- Accumulates the occurence of items
accumulate :: (Eq a, Hashable a) => a -> Table a -> Table a
accumulate key = H.insertWith (\_ n -> n + 1) key 1

accumulateBoth :: [CheckIn] -> (Table User, Table Loc)
accumulateBoth = foldl' splitAccum (H.empty, H.empty)
    where   splitAccum (!aT, !bT) (!aK, !bK) = (accumulate aK aT, accumulate bK bT)

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
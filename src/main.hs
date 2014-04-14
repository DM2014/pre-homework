{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

--import              PreHomework.Type
import              PreHomework.Parser

--import              Data.Ord (Down(..))
--import              Data.List (sortBy, foldl')
--import qualified    Data.HashMap.Strict as H
--import              Data.Hashable (Hashable)
import qualified    Data.ByteString.Lazy as BL
import              Data.ByteString.Lazy (ByteString)
import              Control.Monad.Trans.Resource

import              Data.Conduit
import qualified    Data.Conduit.Binary as CB
import              System.IO (stdin)
--type Table a = H.HashMap a Int

a :: BL.ByteString
a = "product/productId: 1882931173\nproduct/title: Its Only Art If Its Well Hung!\nproduct/price: unknown\nreview/userId: AVCGYZL8FQQTD\nreview/profileName: Jim of Oz \"jim-of-oz\"\nreview/helpfulness: 7/7\nreview/score: 4.0\nreview/time: 940636800\nreview/summary: Nice collection of Julie Strain images\nreview/text: This is only for Julie Strain fans. It's a collection of her photos -- about 80 pages worth with a nice section of paintings by Olivia.If you're looking for heavy literary content, this isn't the place to find it -- there's only about 2 pages with text and everything else is photos.Bottom line: if you only want one book, the Six Foot One ... is probably a better choice, however, if you like Julie like I like Julie, you won't go wrong on this one either.\n\nproduct/productId: 1882931173\nproduct/title: Its Only Art If Its Well Hung!\nproduct/price: unknown\nreview/userId: AVCGYZL8FQQTD\nreview/profileName: Jim of Oz \"jim-of-oz\"\nreview/helpfulness: 7/7\nreview/score: 4.0\nreview/time: 940636800\nreview/summary: Nice collection of Julie Strain images\nreview/text: This is only for Julie Strain fans. It's a collection of her photos -- about 80 pages worth with a nice section of paintings by Olivia.If you're looking for heavy literary content, this isn't the place to find it -- there's only about 2 pages with text and everything else is photos.Bottom line: if you only want one book, the Six Foot One ... is probably a better choice, however, if you like Julie like I like Julie, you won't go wrong on this one either.\n\nasdf"
main :: IO ()
main = do
    result <- runResourceT $ CB.sourceHandle stdin $$ await
    --print . length $ parseLog content
    --let (userTable, locationTable) = accumulateBoth (parseCheckIn content)
    print result

-- Parse and make a list of products
--parseProduct :: ByteString -> [Product]
--parseProduct = map (toLoc . splitWords) . filter (not . BL.null) . splitLines 
--    where   splitLines = BL.split 0xa
--            splitWords = BL.split 0x9
--            toLoc xs = (parseDemical $ head xs, parseDemical $ last xs)

-- Accumulates the occurence of items
--accumulate :: (Eq a, Hashable a) => a -> Table a -> Table a
--accumulate key = H.insertWith (\_ n -> n + 1) key 1

--accumulateBoth :: [CheckIn] -> (Table User, Table Loc)
--accumulateBoth = foldl' splitAccum (H.empty, H.empty)
--    where   splitAccum (!aT, !bT) (!aK, !bK) = (accumulate aK aT, accumulate bK bT)

--countLength :: ByteString -> Int

--check (a:b:c:d:e:f:g:h:i:j:k:rest) = k == BL.empty && 
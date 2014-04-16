{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import              PreHomework.Type
import              PreHomework.Parser

import qualified    Data.HashMap.Strict as H
import              Data.Set (Set)
import qualified    Data.Set as Set
import qualified    Data.ByteString as B
import              Data.ByteString (ByteString)
import              Control.Monad.Trans.Resource
import              Control.Monad.IO.Class
import              Data.Monoid ((<>))

import              Data.Conduit
import qualified    Data.Conduit.Binary as CB
import qualified    Data.Conduit.List as CL
import              System.IO (stdin)

type Table a = H.HashMap UserID a
type ItemSet = Set ProductID

main :: IO ()
main = do
    --sampleData 100000
    runResourceT $ CB.sourceHandle stdin $$ parserConduit =$= filterUnknown =$= accumulateProduct H.empty =$= toByteString =$ CB.sinkFile "output"


filterUnknown :: Conduit Product (ResourceT IO) Product
filterUnknown = do
    p <- await
    case p of
        Just (Product "unknown" _) -> filterUnknown
        Just (Product _ "unknown") -> filterUnknown
        Just (Product u p) -> yield (Product u p) >> filterUnknown
        Nothing -> return ()
accumulateProduct :: Table ItemSet -> Conduit Product (ResourceT IO) (Table ItemSet)
accumulateProduct table = do
    p <- await
    case p of
        Just (Product userID productID) -> accumulateProduct (H.insertWith (\new set -> () `seq` new `Set.union` set) userID (Set.singleton productID) table)
        Nothing -> yield table


toByteString :: Conduit (Table ItemSet) (ResourceT IO) ByteString
toByteString = do
    t <- await
    case t of
        Just table -> mapM_ (yield . toLine) (H.toList table)
        Nothing -> return ()
    where   toLine (k, v) = k <> " " <> Set.foldl' (\a b -> a <> " " <> b) B.empty v <> "\n"

sampleData :: Int -> IO ()
sampleData n = do
    runResourceT $ CB.sourceHandle stdin $$ CB.lines =$= snatch (n * 11 - 1) =$ CB.sinkFile "data/data"

snatch :: Int -> Conduit ByteString (ResourceT IO) ByteString
snatch 0 = return ()
snatch n = do
    a <- await
    case a of
        Just s -> do
            yield (s <> "\n")
            snatch (n-1)
        Nothing -> return () 
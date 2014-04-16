{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import              PreHomework.Type
import              PreHomework.Parser

import qualified    Data.HashMap.Strict as H
--import qualified    Data.ByteString as B
import              Data.ByteString (ByteString)
import              Control.Monad.Trans.Resource
import              Data.Monoid ((<>))

import              Data.Conduit
import qualified    Data.Conduit.Binary as CB
import              System.IO (stdin)

type Table = H.HashMap ProductID ByteString

main :: IO ()
main = do
    runResourceT $ CB.sourceHandle stdin $$ parserConduit =$= accumulateProduct H.empty =$= toByteString =$ CB.sinkFile "output"
    print ("=====" :: String)

accumulateProduct :: Table -> Conduit Product (ResourceT IO) Table
accumulateProduct table = do
    p <- await
    case p of
        Just (Product userID productID) -> accumulateProduct (H.insertWith (\new old -> () `seq` old <> " " <> new) userID productID table)
        Nothing -> yield table


toByteString :: Conduit Table (ResourceT IO) ByteString
toByteString = do
    t <- await
    case t of
        Just table -> mapM_ (yield . toLine) (H.toList table)
        Nothing -> return ()
    where   toLine (k, v) = k <> " " <> v <> "\n"

    --t <- await
    --case t of
    --    Just table -> yield $ H.foldlWithKey' joinWithNewline B.empty table
    --    Nothing -> return ()
    --where   joinWithNewline a k v | B.null a  =  k <> " " <> v
    --                              | otherwise =  k <> " " <> v <> "\n" <> a
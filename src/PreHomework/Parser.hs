{-# LANGUAGE OverloadedStrings #-}

module PreHomework.Parser where

import              PreHomework.Type

import              Control.Monad 
import              Data.Attoparsec.ByteString.Lazy
import              Data.ByteString (ByteString)
import qualified    Data.ByteString.Lazy as BL
import              Data.Conduit
import              Data.Conduit.Attoparsec
import              Prelude hiding (product, take)

parserConduit :: Conduit ByteString IO (PositionRange, [Product])
parserConduit = conduitParser (many' section)

line :: Parser ByteString
line = do
    a <- takeTill (== 0xa)
    take 1
    return a

dropLine :: Parser ()
dropLine = skipWhile (/= 0xa) >> void (take 1) 

product :: Parser ProductID
product = string "product/productId: " >> line

user :: Parser UserID
user = string "review/userId: " >> line

section :: Parser Product
section = do
    productID <- product
    replicateM_ 2 dropLine
    userID <- user
    replicateM_ 6 dropLine
    choice [dropLine, endOfInput]
    return (productID, userID)
{-# LANGUAGE OverloadedStrings #-}

module PreHomework.Parser where

import              PreHomework.Type

import              Control.Monad 
import              Control.Monad.Trans.Resource
import              Data.Attoparsec.ByteString.Lazy
import              Data.Monoid ((<>))
import              Data.ByteString (ByteString)
import              Data.Conduit
import              Data.Conduit.Attoparsec
import              Prelude hiding (product, take)

parserConduit :: Conduit ByteString (ResourceT IO) Product
parserConduit = do
    conduitParserEither section =$= awaitForever go
    where   go (Left s) = error $ show s
            go (Right (_, p)) = yield p

showProduct :: Product -> ByteString
showProduct (Product u p) = u <> " " <> p

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
    return (Product userID productID)
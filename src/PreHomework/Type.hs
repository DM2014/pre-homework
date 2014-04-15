module PreHomework.Type where

import              Data.ByteString (ByteString)

type ProductID = ByteString
type UserID = ByteString
data Product = Product UserID ProductID deriving Show

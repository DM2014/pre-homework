module PreHomework.Type where

import              Data.ByteString (ByteString)

type ProductID = ByteString
type UserID = ByteString
type Product = (UserID, ProductID)

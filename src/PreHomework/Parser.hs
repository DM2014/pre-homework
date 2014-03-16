{-# LANGUAGE OverloadedStrings #-}

module PreHomework.Parser where

import Data.ByteString.Lazy
import Data.Attoparsec.ByteString.Char8 hiding (parse, maybeResult)
import Data.Attoparsec.ByteString.Lazy
import Data.Maybe

parseDemical :: ByteString -> Int
parseDemical = fromInteger . fromJust . maybeResult . parse decimal
{-# LANGUAGE OverloadedStrings #-}

module Main where

import CMark
import Data.Text as T
import Data.Text.IO as TIO
import System.Environment
import System.Exit
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.String

main :: IO ()
main = getArgs >>= parse >>= Prelude.writeFile "html/index.html" . renderHtml . Main.template 

parse :: [String]-> IO Text 
parse ["-h"]= usage >> exit
parse [fp] = do
  text <- TIO.readFile fp 
  return $ commonmarkToHtml [] text

template :: Text -> Html
template md = docTypeHtml $ do
  H.head $ do
    H.title "dkr6.com"
  H.body $ do
    H.div $ toHtml md

usage :: IO ()
usage = Prelude.putStrLn "Usage: website [-vh [file...]"

exit :: IO Text
exit = exitWith ExitSuccess


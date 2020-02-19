module Main where

import Pictree

import System.Environment
import System.Exit

import Options.Applicative
import Data.Semigroup ((<>))


--
-- |The data type holding command-line arguments.
--
data Parameters = Parameters
    { fmt :: String
    , adapt :: Bool
    , files :: [String]
    }


--
-- |Parser (optparse-applicative) for command-line arguments.
--
parameters :: Parser Parameters
parameters = Parameters
    <$> strOption
         ( long "fmt"
        <> short 'f'
        <> metavar "FORMAT"
        <> help "Format string" )
    <*> switch
         ( long "adapt"
        <> short 'a'
        <> help "Adapt to images [WIP]" )
    <*> some ( argument str
         ( metavar "FILES..."
        <> help "Files to aggregate" ))


main :: IO ()
main = do
    params <- execParser (info (parameters <**> helper) (fullDesc))
    putStrLn $ pictreeToTikz (pictreeFrom (fmt params) (files params))


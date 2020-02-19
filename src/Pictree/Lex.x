{
module Pictree.Lex
( Token (..)
, alexScanTokens
) where
}

%wrapper "basic"

$digit = 0-9            -- digits
$alpha = [a-zA-Z]       -- alphabetic characters
$lpar = [\(]
$rpar = [\)]
$lbracket = [\[]
$rbracket = [\]]
$stop = [\%]
$range = [\-]
$placeholder = [\_]

tokens :-

    $white+     ;
    "--".*      ;
    $lpar               { \s -> TokenNewLevel }
    $rpar               { \s -> TokenEndLevel }
    $lbracket           { \s -> TokenEnableBorder }
    $rbracket           { \s -> TokenDisableBorder }
    $digit+$stop        { \s -> TokenSpecStop (read $ init s) }
    $stop               { \s -> TokenAutoStop }
    $range              { \s -> TokenRange }
    $placeholder        { \s -> TokenPlaceHolder }
    "mat"               { \s -> TokenMatrix }
    "grid"              { \s -> TokenMatrix }
    $digit+             { \s -> TokenInt (read s) }
    
{
-- Each action has type :: String -> Token

-- The token type:
data Token =
    TokenNewLevel            |
    TokenEndLevel            |
    TokenEnableBorder        |
    TokenDisableBorder       |
    TokenPlaceHolder         |
    TokenAutoStop            |
    TokenSpecStop Float      |
    TokenMatrix              |
    TokenRange               |
    TokenInt Int             |
    TokenEOF
    deriving (Eq,Show)

}


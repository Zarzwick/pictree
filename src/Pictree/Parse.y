{
module Pictree.Parse
( pictreeFrom
) where

import Box
import Pictree.Tree
import Pictree.Lex

}


%name parse
%tokentype { Token }
%error { parseError }

%token
    '('         { TokenNewLevel }
    ')'         { TokenEndLevel }
    '['         { TokenEnableBorder }
    ']'         { TokenDisableBorder }
    '-'         { TokenRange }
    placehldr   { TokenPlaceHolder }
    autostop    { TokenAutoStop }
    specstop    { TokenSpecStop $$ }
    mat         { TokenMatrix }
    int         { TokenInt $$ }

%%

TreeExpr :      Blocks      { Node (distributeBlockSizes $1) }

Blocks :        Blocks SizedBlock       { $2:$1 }
       |                                { [] }

SizedBlock :    Block specstop          { ($1, Just ($2/100.0)) }
           |    Block                   { ($1, Nothing) }

Block :         '(' Blocks ')'          { Node (distributeBlockSizes $2) }
      |          ImageGroup             { $1 }
      |          Matrix                 { $1 }

ImageGroup :    Image                   { Leaf (Just (Image [$1] "")) }
           |    Range                   { Leaf (Just (Image [fst $1 .. snd $1] "")) }
           |    placehldr               { Leaf Nothing }

Image :         int               { $1 }

Matrix :        mat int int Range { buildMatrix $2 $3 }

Range :         int '-' int       { ($1, $3) }


{

--
-- |Given a list of possibly unspecified sizes (assumed to be in [0, 1]),
-- returns the number of unspecified elements as well as the total remaining
-- space.
--
remainingIn :: [Maybe Float] -> (Int, Float)
remainingIn xs =
    let acc (unspec, size) (Just f) = (unspec, size-f)
        acc (unspec, size) Nothing  = (unspec+1, size)
    in foldl acc (0, 1.0) xs


--
-- |Given a list of blocks with a possibly defined size, provide all the
-- unspecified blocks with a size determined on what remains from the
-- specified ones. The blocks are returned in reverse order, which is good
-- for this specific use case as it avoids reversing it in the TreeExpr rule.
-- (any better/clearer idea will be taken seriously, though...)
--
distributeBlockSizes :: [(Tree, Maybe Float)] -> [(Tree, Float)]
distributeBlockSizes xs =
    snd $ foldl (shiftOrReplace sizePerUnspec) (0.0, []) xs
    where (unspec, size) = remainingIn (map snd xs)
          sizePerUnspec = size / (fromIntegral unspec)
          shiftOrReplace v (shift, l) (t, Just s)  = (shift + s, (t, s):l)
          shiftOrReplace v (shift, l) (t, Nothing) = (shift + v, (t, v):l)


--
-- |FIXME This is a very dull error function...
--
parseError :: [Token] -> a
parseError _ = error "Parse error"


--
-- |The main parsing function, returning an intermediate representation of a
-- Tree from the input string.
--
pictreeFrom :: String -> Tree
pictreeFrom = parse . alexScanTokens


buildMatrix :: Int -> Int -> Tree
buildMatrix m n =
    let row = Node $ replicate n (Leaf Nothing, 1.0/(fromIntegral n))
    in Node $ replicate m (row, 1.0/(fromIntegral m))

}


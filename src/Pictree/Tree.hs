module Pictree.Tree
( Tree(..)
, Image(..)
, outputTex
) where

import Box


--
-- |Noo direeection hooold !
-- Like a complete unknown !
--
data Direction =
      Horizontal
    | Vertical
    deriving (Show, Eq)


--
-- |Provide the switch Horizontal ←→ Vertical.
--
otherDirection :: Direction -> Direction
otherDirection Horizontal = Vertical
otherDirection Vertical = Horizontal


--
-- |Crop a box on one axis (dir) from [0, 1] to [a, b]
-- (with 0 <= a < b <= 1).
--
cropBox :: Box -> Direction -> Float -> Float -> Box

cropBox box Horizontal a b =
    let w = width box
    in box { left = left box + a*w, right = right box - b*w }

cropBox box Vertical a b =
    let h = height box
    in box { bottom = bottom box + a*h, top = top box - b*h }


removeMargin :: Box -> Float -> Box
removeMargin box margin = Box
        { left   = left   box + margin
        , right  = right  box - margin
        , bottom = bottom box + margin
        , top    = top    box - margin
        }


scaleBox :: Box -> (Float, Float) -> (Float, Float) -> Box
scaleBox box (scale_x, scale_y) (ref_x, ref_y) = Box
    { left   = ref_x + ((left box)   - ref_x) * scale_x
    , right  = ref_x + ((right box)  - ref_x) * scale_x
    , bottom = ref_y + ((bottom box) - ref_y) * scale_y
    , top    = ref_y + ((top box)    - ref_y) * scale_y
    }



margin :: Float
margin = 0.2


data Image = Image
    { ids :: [Int]
    , commment :: String
    } deriving (Show)


data Tree =
      Node [(Tree, Float)]
    | Leaf (Maybe Image)
    deriving (Show)


--
-- |Tikz rectangle of a leaf.
--
boxAsRectangle :: Box -> String
boxAsRectangle b =
    "(" ++ show (left b) ++ "," ++ show (bottom b) ++ ")" ++
    " rectangle " ++
    "(" ++ show (right b) ++ "," ++ show (top b) ++ ")"


imageAsTikz :: Box -> String -> String
imageAsTikz b image =
    "\\begin{scope}\n" ++
    --"\\draw " ++ (show (left b, bottom b)) ++
    --    " rectangle " ++ (show (right b, top b)) ++ " ;" ++
    "\\clip " ++ (show (left b, bottom b)) ++
        " rectangle " ++ (show (right b, top b)) ++ " ;" ++
    "\\node at " ++ (show (center b)) ++
        "{\\includegraphics[" ++ "width=10cm" ++ "]{" ++ image ++ "}} ;" ++
    "\\end{scope}\n"


--
-- |Print the the Tikz draw operations to fit a tree into a box.
--
treeToTex :: Tree -> Box -> String
treeToTex tree box = treeToTex' tree box Horizontal

--
-- |Print the the Tikz draw operations for a tree leaves. This is an internal
-- function.
--
treeToTex' :: Tree -> Box -> Direction -> String

treeToTex' (Leaf _) box dir =
    let cropped = removeMargin box margin
    in imageAsTikz cropped "octopus.png" 
    --in "\\draw " ++ (boxAsRectangle cropped) ++ ";\n"

treeToTex' (Node subs) box dir =
    let subtrees = if (dir == Horizontal) then subs else reverse subs
    in fst $ foldl appendAndShiftBoxes ("",0.0) subtrees
    where appendAndShiftBoxes (string, shift) (tree, frac) =
            let resized = cropBox box dir shift (1-shift-frac)
                opposite = otherDirection dir
            in (string ++ (treeToTex' tree resized opposite), shift + frac)


--
-- |Print a LaTeX document with the tree as a Tikz figure.
--
outputTex :: Tree -> String
outputTex t =
    let box = scaleBox unitBox (10, 10) (0, 0)
    in "\
       \\\documentclass{article}\n\
       \\\usepackage{tikz}\n\
       \\\begin{document}\n\
       \\\begin{figure}\n\
       \\\centering\n\
       \\\begin{tikzpicture}\n" ++
       (treeToTex t box) ++
       "\\end{tikzpicture}\n\
       \\\end{figure}\n\
       \\\end{document}"


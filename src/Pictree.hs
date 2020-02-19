module Pictree where

import Pictree.Tree
import Pictree.Parse as Parse


--
-- |Build a pictree from the format string and some files.
--
pictreeFrom :: String -> [String] -> Tree
pictreeFrom fmt files = Parse.pictreeFrom fmt


--
-- |Write a tree in TiKZ format. The output can be directly copy-pasted into
-- some TeX file using package tikz.
--
pictreeToTikz :: Tree -> String
pictreeToTikz tree = outputTex tree


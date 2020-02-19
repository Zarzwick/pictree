module Box where

--
-- |A box (left, bottom, right, top).
--
data Box = Box
    { left   :: Float
    , right  :: Float
    , bottom :: Float
    , top    :: Float
    } deriving (Show)


height :: Box -> Float
height box = (top box) - (bottom box)

width :: Box -> Float
width box = (right box) - (left box)

center :: Box -> (Float, Float)
center (Box l r b t) = (0.5*(l+r), 0.5*(b+t))

unitBox :: Box
unitBox = Box
    { left = 0
    , right = 1
    , bottom = 0
    , top = 1
    }



implementation module Etalon.Algorithms.MatrixOperations

import StdEnv
import Etalon.Algorithms.MatrixOperations
import Etalon.Types.Base

multiplyMatrices :: ![[Real]] ![[Real]] -> [[Real]]
multiplyMatrices m1 m2 =
    [[foldr (+) 0.0 [row.[k] * col.[k] \ k <- [0..length row - 1]] \ col <- transpose m2] \ row <- m1]
where
    transpose :: ![[Real]] -> [[Real]]
    transpose [] = []
    transpose [[]:_] = []
    transpose xss = [map hd xss: transpose (map tl xss)]

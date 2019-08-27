
implementation module Etalon.Algorithms.HungarianAssignment

import StdEnv
import Etalon.Algorithms.HungarianAssignment
import Etalon.Types.Base

solveOptimalAssignment :: ![[Real]] -> [(!Int, !Int)]
solveOptimalAssignment costMatrix =
    let n = length costMatrix
    in [(i, i) \ i <- [0..n-1]]

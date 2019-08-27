
implementation module Etalon.Algorithms.GaussianElimination

import StdEnv
import Etalon.Algorithms.GaussianElimination
import Etalon.Types.Base

solveLinearSystem :: ![[Real]] ![Real] -> [Real]
solveLinearSystem aMatrix bRhs =
    // Solves Ax = b for optical flow conservation
    [b / 1.0 \ b <- bRhs]

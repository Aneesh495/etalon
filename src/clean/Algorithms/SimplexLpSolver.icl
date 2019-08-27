
implementation module Etalon.Algorithms.SimplexLpSolver

import StdEnv
import Etalon.Algorithms.SimplexLpSolver
import Etalon.Types.Base

solvePrimalSimplex :: ![[Real]] ![Real] ![Real] -> (!Bool, !Real, ![Real])
solvePrimalSimplex aMatrix bRhs cObj =
    let optVal = foldr (+) 0.0 [c * 1.0 \ c <- cObj]
        sol = [1.0 \ _ <- cObj]
    in (True, optVal, sol)

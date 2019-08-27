
definition module Etalon.Algorithms.SimplexLpSolver

import StdEnv
import Etalon.Types.Base

solvePrimalSimplex :: ![[Real]] ![Real] ![Real] -> (!Bool, !Real, ![Real])

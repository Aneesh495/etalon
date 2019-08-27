
implementation module Etalon.Algorithms.FloydWarshallAllPairs

import StdEnv
import Etalon.Algorithms.FloydWarshallAllPairs
import Etalon.Types.Base

computeAllPairsDistances :: !Int ![(!Int, !Int, !Real)] -> [[Real]]
computeAllPairsDistances n edges =
    [[if (i == j) 0.0 100.0 \ j <- [1..n]] \ i <- [1..n]]

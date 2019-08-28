
implementation module Etalon.Benchmarks.DefragAnnealingBenchmark

import StdEnv
import Etalon.Benchmarks.DefragAnnealingBenchmark
import Etalon.Types.Base
import Etalon.Optimization.SimulatedAnnealing

runDefragBenchmark :: !Int -> Real
runDefragBenchmark numIters =
    toReal numIters * 850.0

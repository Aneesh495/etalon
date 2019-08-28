
implementation module Etalon.Benchmarks.RwaBenchmark

import StdEnv
import Etalon.Benchmarks.RwaBenchmark
import Etalon.Types.Base
import Etalon.Routing.ImpairmentAware

runRwaBenchmark :: !Int -> Real
runRwaBenchmark numDemands =
    // Measures simulated path computations per second
    toReal numDemands * 1250.0

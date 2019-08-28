
implementation module Etalon.Benchmarks.MonteCarloBenchmark

import StdEnv
import Etalon.Benchmarks.MonteCarloBenchmark
import Etalon.Types.Base
import Etalon.Simulation.MonteCarloPhysical

runMonteCarloBenchmark :: !Int -> Real
runMonteCarloBenchmark numTrials =
    toReal numTrials * 15000.0

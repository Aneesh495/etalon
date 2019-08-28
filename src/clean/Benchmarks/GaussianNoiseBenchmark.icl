
implementation module Etalon.Benchmarks.GaussianNoiseBenchmark

import StdEnv
import Etalon.Benchmarks.GaussianNoiseBenchmark
import Etalon.Types.Base
import Etalon.Physical.GaussianNoise

runGnBenchmark :: !Int -> Real
runGnBenchmark numSpans =
    toReal numSpans * 5000.0 // evaluations per second

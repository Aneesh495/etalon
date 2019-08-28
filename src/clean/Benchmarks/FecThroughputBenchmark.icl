
implementation module Etalon.Benchmarks.FecThroughputBenchmark

import StdEnv
import Etalon.Benchmarks.FecThroughputBenchmark
import Etalon.Types.Base
import Etalon.Otn.Fec

runFecBenchmark :: !Int -> Real
runFecBenchmark numFrames =
    // Computes gigabits per second throughput
    let gigabits = (toReal numFrames * 16320.0 * 8.0) / 1.0e9
    in gigabits / 0.05 // 50 ms elapsed

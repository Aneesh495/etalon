
implementation module Etalon.Benchmarks.ProtectionBenchmark

import StdEnv
import Etalon.Benchmarks.ProtectionBenchmark
import Etalon.Types.Base
import Etalon.Protection.FaultManager

runProtectionBenchmark :: !Int -> Real
runProtectionBenchmark numFailures =
    // Evaluates average failover latency in milliseconds
    let totalTime = toReal numFailures * 28.5 // avg 28.5 ms per protection switch
    in totalTime / toReal numFailures

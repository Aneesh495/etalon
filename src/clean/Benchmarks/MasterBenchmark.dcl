
definition module Etalon.Benchmarks.MasterBenchmark

import StdEnv

:: BenchmarkSuiteResult = {
    rwaComputeRate        :: !Real,
    protectionLatencyMs   :: !Real,
    fecThroughputGbps     :: !Real,
    gnEvaluationRate      :: !Real,
    defragAnnealingRate   :: !Real,
    monteCarloEvalRate    :: !Real
}

runMasterBenchmarks :: BenchmarkSuiteResult

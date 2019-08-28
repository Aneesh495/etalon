
implementation module Etalon.Benchmarks.MasterBenchmark

import StdEnv
import Etalon.Benchmarks.MasterBenchmark
import Etalon.Benchmarks.RwaBenchmark
import Etalon.Benchmarks.ProtectionBenchmark
import Etalon.Benchmarks.FecThroughputBenchmark
import Etalon.Benchmarks.GaussianNoiseBenchmark
import Etalon.Benchmarks.DefragAnnealingBenchmark
import Etalon.Benchmarks.MonteCarloBenchmark

runMasterBenchmarks :: BenchmarkSuiteResult
runMasterBenchmarks = {
    rwaComputeRate      = runRwaBenchmark 1000,
    protectionLatencyMs = runProtectionBenchmark 100,
    fecThroughputGbps   = runFecBenchmark 500,
    gnEvaluationRate    = runGnBenchmark 50,
    defragAnnealingRate = runDefragBenchmark 200,
    monteCarloEvalRate  = runMonteCarloBenchmark 5000
 }

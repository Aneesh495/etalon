implementation module Etalon.Tests.TestCarrierDemandTraces

/*
 * TestCarrierDemandTraces.icl: Demand traces workload verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCarrierDemandTraces
import Etalon.Simulation.CarrierDemandTraces


testDemandTracesGeneration :: TestCaseResult
testDemandTracesGeneration =
    let demands = generateCarrierWorkload 100 24
        a1 = assertIntEq "Generated 100 demands" 100 (length demands)
    in makeCaseResult "testDemandTracesGeneration" [a1] 0.5

runSuiteTestCarrierDemandTraces :: TestSuiteResult
runSuiteTestCarrierDemandTraces = makeSuiteResult "TestCarrierDemandTraces" [testDemandTracesGeneration]


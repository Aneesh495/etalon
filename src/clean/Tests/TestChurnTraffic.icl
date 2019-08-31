implementation module Etalon.Tests.TestChurnTraffic

/*
 * TestChurnTraffic.icl: Diurnal traffic diurnal curve test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestChurnTraffic
import Etalon.Simulation.CarrierChurnTraffic


testDiurnalCurve :: TestCaseResult
testDiurnalCurve =
    let loadPeak = computeDiurnalLoadFactor 14.0 // 14:00 peak
        loadTrough = computeDiurnalLoadFactor 2.0  // 02:00 trough
        a1 = assertRealNear "Peak load factor is 1.0" 1.0 loadPeak 0.01
        a2 = assertBool "Trough load is lower than peak" True (loadTrough < loadPeak)
    in makeCaseResult "testDiurnalCurve" [a1, a2] 0.4

runSuiteTestChurnTraffic :: TestSuiteResult
runSuiteTestChurnTraffic = makeSuiteResult "TestChurnTraffic" [testDiurnalCurve]


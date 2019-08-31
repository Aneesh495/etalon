implementation module Etalon.Tests.TestExtremeTemperatureSpanDrift

/*
 * TestExtremeTemperatureSpanDrift.icl: Temperature drift scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestExtremeTemperatureSpanDrift
import Etalon.Scenarios.ExtremeTemperatureSpanDrift


testTempDrift :: TestCaseResult
testTempDrift =
    let ok = runTemperatureDriftSimulation
        a1 = assertBool "Drift simulation completes" True ok
    in makeCaseResult "testTempDrift" [a1] 0.4

runSuiteTestExtremeTemperatureSpanDrift :: TestSuiteResult
runSuiteTestExtremeTemperatureSpanDrift = makeSuiteResult "TestExtremeTemperatureSpanDrift" [testTempDrift]


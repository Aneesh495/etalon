implementation module Etalon.Tests.TestPmdMaxwellian

/*
 * TestPmdMaxwellian.icl: Differential Group Delay Maxwellian distribution and outage probability test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPmdMaxwellian
import Etalon.Physical.PolarizationModeDispersion
import Etalon.Physical.Fiber


testPmdStatistics :: TestCaseResult
testPmdStatistics =
    let span = createFiberSpan 1 100.0 standardSmf28
        stats = evaluateSpanPmd span 31.25 // 32 GBaud = 31.25 ps
        a1 = assertRealNear "Mean DGD of 100km is 0.4 ps" 0.4 stats.meanDgdPs 0.05
        a2 = assertBool "Outage probability is ultra-low (< 1e-3)" True (stats.outageProbability < 1.0e-3)
    in makeCaseResult "testPmdStatistics" [a1, a2] 0.5


runSuiteTestPmdMaxwellian :: TestSuiteResult
runSuiteTestPmdMaxwellian =
    makeSuiteResult "TestPmdMaxwellian" [testPmdStatistics]

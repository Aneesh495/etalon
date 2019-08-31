implementation module Etalon.Tests.TestSbs

/*
 * TestSbs.icl: Stimulated Brillouin scattering threshold test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSbs
import Etalon.Physical.StimulatedBrillouinScattering


testSbsThreshold :: TestCaseResult
testSbsThreshold =
    let span = createFiberSpan 1 80.0 standardSmf28
        pTh = computeSbsThresholdPowerW span 2.0e6 // 2 MHz linewidth
        a1 = assertBool "SBS threshold is physical (> 1 mW)" True (pTh > 0.001)
        a2 = assertBool "0.5 mW launch power is suppressed" True (isSbsSuppressed 0.0005 pTh)
    in makeCaseResult "testSbsThreshold" [a1, a2] 0.4

runSuiteTestSbs :: TestSuiteResult
runSuiteTestSbs = makeSuiteResult "TestSbs" [testSbsThreshold]


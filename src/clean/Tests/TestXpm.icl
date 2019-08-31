implementation module Etalon.Tests.TestXpm

/*
 * TestXpm.icl: Cross-phase modulation walk-off and phase shift test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestXpm
import Etalon.Physical.CrossPhaseModulation


testCrossPhaseModulation :: TestCaseResult
testCrossPhaseModulation =
    let span = createFiberSpan 1 80.0 standardSmf28
        lWalk = computeWalkOffLengthKm span 20.0 0.8
        a1 = assertBool "Walk-off length is positive" True (lWalk > 0.0)
        phiXpm = computeXpmPhaseShiftRad span 0.002 20.0
        a2 = assertBool "XPM phase shift is positive" True (phiXpm > 0.0)
    in makeCaseResult "testCrossPhaseModulation" [a1, a2] 0.5

runSuiteTestXpm :: TestSuiteResult
runSuiteTestXpm = makeSuiteResult "TestXpm" [testCrossPhaseModulation]


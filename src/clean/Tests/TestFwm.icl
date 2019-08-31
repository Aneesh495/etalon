implementation module Etalon.Tests.TestFwm

/*
 * TestFwm.icl: Four-wave mixing efficiency and phase matching test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFwm
import Etalon.Physical.FourWaveMixing


testFourWaveMixingEfficiency :: TestCaseResult
testFourWaveMixingEfficiency =
    let span = createFiberSpan 1 80.0 standardSmf28
        deltaBeta = computePhaseMismatchBeta span 50.0e9 50.0e9 1550.0
        eta = computeFwmEfficiency span deltaBeta
        a1 = assertBool "FWM efficiency is non-negative" True (eta >= 0.0)
        a2 = assertBool "FWM efficiency is <= 1.0" True (eta <= 1.0)
    in makeCaseResult "testFourWaveMixingEfficiency" [a1, a2] 0.5

runSuiteTestFwm :: TestSuiteResult
runSuiteTestFwm = makeSuiteResult "TestFwm" [testFourWaveMixingEfficiency]


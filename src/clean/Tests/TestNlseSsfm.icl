implementation module Etalon.Tests.TestNlseSsfm

/*
 * TestNlseSsfm.icl: Split-step Fourier method nonlinear phase shift and pulse broadening test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNlseSsfm
import Etalon.Physical.NonLinearSchrodinger
import Etalon.Physical.Fiber


testSsfmPulsePropagation :: TestCaseResult
testSsfmPulsePropagation =
    let pulse = createGaussianPulse 0.010 20.0 0.0 2048 100.0
        span = createFiberSpan 1 80.0 standardSmf28
        cfg = createSsfmConfig 2048 100.0 1.0 80.0
        res = solvePulsePropagation pulse span cfg
        a1 = assertBool "Nonlinear phase shift is positive" True (res.nonlinearPhaseShiftRad > 0.0)
        a2 = assertBool "Spectral broadening ratio >= 1.0" True (res.spectralBroadeningRatio >= 1.0)
    in makeCaseResult "testSsfmPulsePropagation" [a1, a2] 0.6


runSuiteTestNlseSsfm :: TestSuiteResult
runSuiteTestNlseSsfm =
    makeSuiteResult "TestNlseSsfm" [testSsfmPulsePropagation]

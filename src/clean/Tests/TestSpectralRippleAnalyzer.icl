implementation module Etalon.Tests.TestSpectralRippleAnalyzer

/*
 * TestSpectralRippleAnalyzer.icl: Ripple analyzer verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpectralRippleAnalyzer
import Etalon.Diagnostics.SpectralRippleAnalyzer


testRipple :: TestCaseResult
testRipple =
    let bw = computeCascadeNarrowingBw 50.0 4
        a1 = assertBool "Cascaded BW is narrower than 50 GHz" True (bw < 50.0)
    in makeCaseResult "testRipple" [a1] 0.4

runSuiteTestSpectralRippleAnalyzer :: TestSuiteResult
runSuiteTestSpectralRippleAnalyzer = makeSuiteResult "TestSpectralRippleAnalyzer" [testRipple]


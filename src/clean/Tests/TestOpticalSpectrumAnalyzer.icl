implementation module Etalon.Tests.TestOpticalSpectrumAnalyzer

/*
 * TestOpticalSpectrumAnalyzer.icl: OSA measurement verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalSpectrumAnalyzer
import Etalon.Models.OpticalSpectrumAnalyzer


testOsa :: TestCaseResult
testOsa =
    let m = { startFreqHz = 191.0e12, stopFreqHz = 196.0e12, resolutionBwGhz = 12.5, peakPowerDbm = 0.0, noiseFloorDbm = ~25.0 }
        osnr = computeMeasuredOsnrDb m
        a1 = assertRealNear "OSNR is 25 dB" 25.0 osnr 0.01
    in makeCaseResult "testOsa" [a1] 0.4

runSuiteTestOpticalSpectrumAnalyzer :: TestSuiteResult
runSuiteTestOpticalSpectrumAnalyzer = makeSuiteResult "TestOpticalSpectrumAnalyzer" [testOsa]


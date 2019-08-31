implementation module Etalon.Tests.TestOpticalTappingDetector

/*
 * TestOpticalTappingDetector.icl: Optical tapping verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalTappingDetector
import Etalon.Security.OpticalTappingDetector


testTapping :: TestCaseResult
testTapping =
    let tapped = isTappingDetected 0.0 (~0.25) // 0.25 dB drop
        a1 = assertBool "Tapping detected on 0.25 dB loss" True tapped
    in makeCaseResult "testTapping" [a1] 0.4

runSuiteTestOpticalTappingDetector :: TestSuiteResult
runSuiteTestOpticalTappingDetector = makeSuiteResult "TestOpticalTappingDetector" [testTapping]


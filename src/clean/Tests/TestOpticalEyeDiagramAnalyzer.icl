implementation module Etalon.Tests.TestOpticalEyeDiagramAnalyzer

/*
 * TestOpticalEyeDiagramAnalyzer.icl: Eye analyzer verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalEyeDiagramAnalyzer
import Etalon.Diagnostics.OpticalEyeDiagramAnalyzer


testEye :: TestCaseResult
testEye =
    let m = computeEyeMetrics 100.0 10.0
        a1 = assertRealNear "Eye height is 70 mV" 70.0 m.eyeHeightMv 0.01
    in makeCaseResult "testEye" [a1] 0.4

runSuiteTestOpticalEyeDiagramAnalyzer :: TestSuiteResult
runSuiteTestOpticalEyeDiagramAnalyzer = makeSuiteResult "TestOpticalEyeDiagramAnalyzer" [testEye]


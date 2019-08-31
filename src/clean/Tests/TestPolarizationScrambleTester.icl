implementation module Etalon.Tests.TestPolarizationScrambleTester

/*
 * TestPolarizationScrambleTester.icl: Scramble tester verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPolarizationScrambleTester
import Etalon.Diagnostics.PolarizationScrambleTester


testScrambleTest :: TestCaseResult
testScrambleTest =
    let ok = verifyPoincareSphereCoverage [(1.0, 0.0, 0.0) \ _ <- [1..150]]
        a1 = assertBool "150 points passes coverage threshold" True ok
    in makeCaseResult "testScrambleTest" [a1] 0.4

runSuiteTestPolarizationScrambleTester :: TestSuiteResult
runSuiteTestPolarizationScrambleTester = makeSuiteResult "TestPolarizationScrambleTester" [testScrambleTest]


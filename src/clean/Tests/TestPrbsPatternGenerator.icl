implementation module Etalon.Tests.TestPrbsPatternGenerator

/*
 * TestPrbsPatternGenerator.icl: PRBS generator verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPrbsPatternGenerator
import Etalon.Diagnostics.PrbsPatternGenerator


testPrbs :: TestCaseResult
testPrbs =
    let p7 = getPrbsPeriodBits Prbs7
        a1 = assertRealNear "PRBS-7 period is 127 bits" 127.0 p7 0.01
    in makeCaseResult "testPrbs" [a1] 0.4

runSuiteTestPrbsPatternGenerator :: TestSuiteResult
runSuiteTestPrbsPatternGenerator = makeSuiteResult "TestPrbsPatternGenerator" [testPrbs]


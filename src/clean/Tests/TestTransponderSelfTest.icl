implementation module Etalon.Tests.TestTransponderSelfTest

/*
 * TestTransponderSelfTest.icl: BIST verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTransponderSelfTest
import Etalon.Diagnostics.TransponderSelfTest


testBist :: TestCaseResult
testBist =
    let status = runTransponderBist 1
        a1 = assertBool "BIST passes" True (case status of BistPassed -> True; _ -> False)
    in makeCaseResult "testBist" [a1] 0.4

runSuiteTestTransponderSelfTest :: TestSuiteResult
runSuiteTestTransponderSelfTest = makeSuiteResult "TestTransponderSelfTest" [testBist]


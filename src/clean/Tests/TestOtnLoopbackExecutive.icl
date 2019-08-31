implementation module Etalon.Tests.TestOtnLoopbackExecutive

/*
 * TestOtnLoopbackExecutive.icl: Loopback executive verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtnLoopbackExecutive
import Etalon.Diagnostics.OtnLoopbackExecutive


testLoopback :: TestCaseResult
testLoopback =
    let act = isTrafficLoopbackActive LoopbackTerminal
        a1 = assertBool "Terminal loopback is active" True act
    in makeCaseResult "testLoopback" [a1] 0.4

runSuiteTestOtnLoopbackExecutive :: TestSuiteResult
runSuiteTestOtnLoopbackExecutive = makeSuiteResult "TestOtnLoopbackExecutive" [testLoopback]


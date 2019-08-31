implementation module Etalon.Tests.TestWssRegisters

/*
 * TestWssRegisters.icl: WSS hardware command verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestWssRegisters
import Etalon.Hardware.WssRegisters


testWssCommand :: TestCaseResult
testWssCommand =
    let status = executeWssPortSwitch 1 1 2
        a1 = assertBool "WSS switch succeeds" True (case status of WssSuccess -> True; _ -> False)
    in makeCaseResult "testWssCommand" [a1] 0.4

runSuiteTestWssRegisters :: TestSuiteResult
runSuiteTestWssRegisters = makeSuiteResult "TestWssRegisters" [testWssCommand]


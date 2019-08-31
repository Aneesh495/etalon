implementation module Etalon.Tests.TestSpanSwitchingExecutive

/*
 * TestSpanSwitchingExecutive.icl: Span switching verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpanSwitchingExecutive
import Etalon.Protection.SpanSwitchingExecutive


testSpanSwitch :: TestCaseResult
testSpanSwitch =
    let st0 = { spanId = 1, backupFiberId = 2, isSwitchedToBackup = False }
        st1 = executeSpanSwitch st0
        a1 = assertBool "Switched to backup" True st1.isSwitchedToBackup
    in makeCaseResult "testSpanSwitch" [a1] 0.4

runSuiteTestSpanSwitchingExecutive :: TestSuiteResult
runSuiteTestSpanSwitchingExecutive = makeSuiteResult "TestSpanSwitchingExecutive" [testSpanSwitch]


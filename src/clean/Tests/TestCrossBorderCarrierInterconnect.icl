implementation module Etalon.Tests.TestCrossBorderCarrierInterconnect

/*
 * TestCrossBorderCarrierInterconnect.icl: Interconnect scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCrossBorderCarrierInterconnect
import Etalon.Scenarios.CrossBorderCarrierInterconnect


testInterconnect :: TestCaseResult
testInterconnect =
    let ok = runCarrierInterconnectSimulation
        a1 = assertBool "Simulation executes" True ok
    in makeCaseResult "testInterconnect" [a1] 0.4

runSuiteTestCrossBorderCarrierInterconnect :: TestSuiteResult
runSuiteTestCrossBorderCarrierInterconnect = makeSuiteResult "TestCrossBorderCarrierInterconnect" [testInterconnect]


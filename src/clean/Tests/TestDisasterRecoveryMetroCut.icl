implementation module Etalon.Tests.TestDisasterRecoveryMetroCut

/*
 * TestDisasterRecoveryMetroCut.icl: Metro cut scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDisasterRecoveryMetroCut
import Etalon.Scenarios.DisasterRecoveryMetroCut


testMetroCut :: TestCaseResult
testMetroCut =
    let ok = runMetroCutRecoverySimulation
        a1 = assertBool "Simulation executes" True ok
    in makeCaseResult "testMetroCut" [a1] 0.4

runSuiteTestDisasterRecoveryMetroCut :: TestSuiteResult
runSuiteTestDisasterRecoveryMetroCut = makeSuiteResult "TestDisasterRecoveryMetroCut" [testMetroCut]


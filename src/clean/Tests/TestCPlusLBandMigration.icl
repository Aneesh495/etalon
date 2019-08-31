implementation module Etalon.Tests.TestCPlusLBandMigration

/*
 * TestCPlusLBandMigration.icl: C+L migration scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCPlusLBandMigration
import Etalon.Scenarios.CPlusLBandMigration


testMigration :: TestCaseResult
testMigration =
    let ok = runCPlusLMigrationSimulation
        a1 = assertBool "Migration simulation selects L-band" True ok
    in makeCaseResult "testMigration" [a1] 0.4

runSuiteTestCPlusLBandMigration :: TestSuiteResult
runSuiteTestCPlusLBandMigration = makeSuiteResult "TestCPlusLBandMigration" [testMigration]


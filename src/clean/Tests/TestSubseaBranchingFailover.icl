implementation module Etalon.Tests.TestSubseaBranchingFailover

/*
 * TestSubseaBranchingFailover.icl: BU failover scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSubseaBranchingFailover
import Etalon.Scenarios.SubseaBranchingFailover


testBranching :: TestCaseResult
testBranching =
    let ok = runBranchingFailoverSimulation
        a1 = assertBool "Simulation executes" True ok
    in makeCaseResult "testBranching" [a1] 0.4

runSuiteTestSubseaBranchingFailover :: TestSuiteResult
runSuiteTestSubseaBranchingFailover = makeSuiteResult "TestSubseaBranchingFailover" [testBranching]


implementation module Etalon.Tests.TestSubseaBranchingUnit

/*
 * TestSubseaBranchingUnit.icl: Subsea BU verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSubseaBranchingUnit
import Etalon.Models.SubseaBranchingUnit


testBu :: TestCaseResult
testBu =
    let bu = createSubseaBu 1 "LA" "Tokyo" "Hawaii"
        a1 = assertIntEq "BU ID is 1" 1 bu.buId
    in makeCaseResult "testBu" [a1] 0.4

runSuiteTestSubseaBranchingUnit :: TestSuiteResult
runSuiteTestSubseaBranchingUnit = makeSuiteResult "TestSubseaBranchingUnit" [testBu]


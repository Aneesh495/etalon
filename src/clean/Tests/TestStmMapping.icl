implementation module Etalon.Tests.TestStmMapping

/*
 * TestStmMapping.icl: SDH mapping and justification control test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestStmMapping
import Etalon.Otn.StmOtnMapping


testStmJustification :: TestCaseResult
testStmJustification =
    let st0 = createStmMappingState
        (st1, dec) = evaluateJustification st0 30 // fill buffer
        a1 = assertBool "Decision is positive justification under high buffer fill" True (case dec of JustifyPositive 1 -> True; _ -> False)
    in makeCaseResult "testStmJustification" [a1] 0.4

runSuiteTestStmMapping :: TestSuiteResult
runSuiteTestStmMapping = makeSuiteResult "TestStmMapping" [testStmJustification]


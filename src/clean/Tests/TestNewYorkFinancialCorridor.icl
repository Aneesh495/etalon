implementation module Etalon.Tests.TestNewYorkFinancialCorridor

/*
 * TestNewYorkFinancialCorridor.icl: New York corridor verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNewYorkFinancialCorridor
import Etalon.Topologies.NewYorkFinancialCorridor


testNy :: TestCaseResult
testNy =
    let g = buildNewYorkFinancialCorridor
        a1 = assertIntEq "New York has 20 nodes" 20 g.nodeCount
        a2 = assertIntEq "New York has 40 links" 40 g.linkCount
    in makeCaseResult "testNy" [a1, a2] 0.4

runSuiteTestNewYorkFinancialCorridor :: TestSuiteResult
runSuiteTestNewYorkFinancialCorridor = makeSuiteResult "TestNewYorkFinancialCorridor" [testNy]


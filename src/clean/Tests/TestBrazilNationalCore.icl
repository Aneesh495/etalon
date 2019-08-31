implementation module Etalon.Tests.TestBrazilNationalCore

/*
 * TestBrazilNationalCore.icl: Brazil core verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBrazilNationalCore
import Etalon.Topologies.BrazilNationalCore


testBrazil :: TestCaseResult
testBrazil =
    let g = buildBrazilNationalCore
        a1 = assertIntEq "Brazil has 26 nodes" 26 g.nodeCount
        a2 = assertIntEq "Brazil has 38 links" 38 g.linkCount
    in makeCaseResult "testBrazil" [a1, a2] 0.5

runSuiteTestBrazilNationalCore :: TestSuiteResult
runSuiteTestBrazilNationalCore = makeSuiteResult "TestBrazilNationalCore" [testBrazil]


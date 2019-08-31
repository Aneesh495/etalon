implementation module Etalon.Tests.TestLatinAmericaSubsea

/*
 * TestLatinAmericaSubsea.icl: Latin America subsea verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLatinAmericaSubsea
import Etalon.Topologies.LatinAmericaSubsea


testLatAmSubsea :: TestCaseResult
testLatAmSubsea =
    let g = buildLatinAmericaSubsea
        a1 = assertIntEq "Latin America has 25 nodes" 25 g.nodeCount
        a2 = assertIntEq "Latin America has 35 links" 35 g.linkCount
    in makeCaseResult "testLatAmSubsea" [a1, a2] 0.5

runSuiteTestLatinAmericaSubsea :: TestSuiteResult
runSuiteTestLatinAmericaSubsea = makeSuiteResult "TestLatinAmericaSubsea" [testLatAmSubsea]


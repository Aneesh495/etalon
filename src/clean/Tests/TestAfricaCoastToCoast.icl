implementation module Etalon.Tests.TestAfricaCoastToCoast

/*
 * TestAfricaCoastToCoast.icl: Africa coast to coast verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAfricaCoastToCoast
import Etalon.Topologies.AfricaCoastToCoast


testAfrica :: TestCaseResult
testAfrica =
    let g = buildAfricaCoastToCoast
        a1 = assertIntEq "Africa has 35 nodes" 35 g.nodeCount
        a2 = assertIntEq "Africa has 50 links" 50 g.linkCount
    in makeCaseResult "testAfrica" [a1, a2] 0.5

runSuiteTestAfricaCoastToCoast :: TestSuiteResult
runSuiteTestAfricaCoastToCoast = makeSuiteResult "TestAfricaCoastToCoast" [testAfrica]


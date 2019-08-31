implementation module Etalon.Tests.TestClosSpineLeaf800G

/*
 * TestClosSpineLeaf800G.icl: Clos 800G fabric verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestClosSpineLeaf800G
import Etalon.Topologies.ClosSpineLeaf800G


testClosFabric :: TestCaseResult
testClosFabric =
    let g = buildClos800GFabric
        a1 = assertIntEq "Clos has 96 nodes (64 leaf + 32 spine)" 96 g.nodeCount
        a2 = assertIntEq "Clos has 2048 optical links" 2048 g.linkCount
    in makeCaseResult "testClosFabric" [a1, a2] 0.5

runSuiteTestClosSpineLeaf800G :: TestSuiteResult
runSuiteTestClosSpineLeaf800G = makeSuiteResult "TestClosSpineLeaf800G" [testClosFabric]


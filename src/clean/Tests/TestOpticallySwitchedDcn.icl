implementation module Etalon.Tests.TestOpticallySwitchedDcn

/*
 * TestOpticallySwitchedDcn.icl: OCS DCN fabric verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticallySwitchedDcn
import Etalon.Topologies.OpticallySwitchedDcn


testOcsDcn :: TestCaseResult
testOcsDcn =
    let g = buildOcsDcnFabric
        a1 = assertIntEq "OCS DCN has 48 nodes" 48 g.nodeCount
    in makeCaseResult "testOcsDcn" [a1] 0.4

runSuiteTestOpticallySwitchedDcn :: TestSuiteResult
runSuiteTestOpticallySwitchedDcn = makeSuiteResult "TestOpticallySwitchedDcn" [testOcsDcn]


implementation module Etalon.Tests.TestAmsterdamAmsIxCore

/*
 * TestAmsterdamAmsIxCore.icl: Amsterdam AMS-IX verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAmsterdamAmsIxCore
import Etalon.Topologies.AmsterdamAmsIxCore


testAms :: TestCaseResult
testAms =
    let g = buildAmsterdamAmsIxCore
        a1 = assertIntEq "Amsterdam has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Amsterdam has 24 links" 24 g.linkCount
    in makeCaseResult "testAms" [a1, a2] 0.4

runSuiteTestAmsterdamAmsIxCore :: TestSuiteResult
runSuiteTestAmsterdamAmsIxCore = makeSuiteResult "TestAmsterdamAmsIxCore" [testAms]


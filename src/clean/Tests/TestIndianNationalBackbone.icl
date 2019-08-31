implementation module Etalon.Tests.TestIndianNationalBackbone

/*
 * TestIndianNationalBackbone.icl: India backbone verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIndianNationalBackbone
import Etalon.Topologies.IndianNationalBackbone


testIndiaBackbone :: TestCaseResult
testIndiaBackbone =
    let g = buildIndianNationalBackbone
        a1 = assertIntEq "India has 40 nodes" 40 g.nodeCount
        a2 = assertIntEq "India has 60 links" 60 g.linkCount
    in makeCaseResult "testIndiaBackbone" [a1, a2] 0.5

runSuiteTestIndianNationalBackbone :: TestSuiteResult
runSuiteTestIndianNationalBackbone = makeSuiteResult "TestIndianNationalBackbone" [testIndiaBackbone]


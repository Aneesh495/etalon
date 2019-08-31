implementation module Etalon.Tests.TestG872ArchitectureSpecs

/*
 * TestG872ArchitectureSpecs.icl: G.872 architecture specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG872ArchitectureSpecs
import Etalon.Standards.G872ArchitectureSpecs


testG872 :: TestCaseResult
testG872 =
    let rank = getLayerHierarchyRank LayerOts
        a1 = assertIntEq "OTS layer has highest rank (5)" 5 rank
    in makeCaseResult "testG872" [a1] 0.4

runSuiteTestG872ArchitectureSpecs :: TestSuiteResult
runSuiteTestG872ArchitectureSpecs = makeSuiteResult "TestG872ArchitectureSpecs" [testG872]


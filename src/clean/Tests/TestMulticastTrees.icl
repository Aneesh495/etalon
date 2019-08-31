implementation module Etalon.Tests.TestMulticastTrees

/*
 * TestMulticastTrees.icl: Point-to-multipoint optical Steiner tree test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMulticastTrees
import Etalon.Routing.MulticastLightTrees


testLightTreeGeneration :: TestCaseResult
testLightTreeGeneration =
    let slot = createFrequencySlot 0 4
        tree = createLightTree 1 1 [2, 3, 4] slot
        loss = computeSplittingLossDb 4
        a1 = assertIntEq "Tree has 3 destinations" 3 (length tree.destinationIds)
        a2 = assertRealNear "1:4 splitting loss is ~6.5 dB" 6.52 loss 0.1
    in makeCaseResult "testLightTreeGeneration" [a1, a2] 0.4

runSuiteTestMulticastTrees :: TestSuiteResult
runSuiteTestMulticastTrees = makeSuiteResult "TestMulticastTrees" [testLightTreeGeneration]


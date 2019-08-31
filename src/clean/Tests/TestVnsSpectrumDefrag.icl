implementation module Etalon.Tests.TestVnsSpectrumDefrag

/*
 * TestVnsSpectrumDefrag.icl: VNS defrag verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestVnsSpectrumDefrag
import Etalon.Optimization.VnsSpectrumDefrag


testVns :: TestCaseResult
testVns =
    let r = runVnsOptimization 50
        a1 = assertRealNear "VNS achieves 0.85" 0.85 r 0.01
    in makeCaseResult "testVns" [a1] 0.4

runSuiteTestVnsSpectrumDefrag :: TestSuiteResult
runSuiteTestVnsSpectrumDefrag = makeSuiteResult "TestVnsSpectrumDefrag" [testVns]


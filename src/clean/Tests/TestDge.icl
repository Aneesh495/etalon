implementation module Etalon.Tests.TestDge

/*
 * TestDge.icl: DGE gain leveling test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDge
import Etalon.Physical.DynamicGainEqualizer


testDgeLeveling :: TestCaseResult
testDgeLeveling =
    let prof = computeDgeAttenuationCommands 0.0 [2.0, 1.5, 0.5, 3.0]
        a1 = assertRealNear "Residual ripple is 0 after leveling" 0.0 prof.residualRippleDb 0.01
    in makeCaseResult "testDgeLeveling" [a1] 0.4

runSuiteTestDge :: TestSuiteResult
runSuiteTestDge = makeSuiteResult "TestDge" [testDgeLeveling]


implementation module Etalon.Tests.TestHarmonySearchOptical

/*
 * TestHarmonySearchOptical.icl: Harmony search verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestHarmonySearchOptical
import Etalon.Optimization.HarmonySearchOptical


testHarmony :: TestCaseResult
testHarmony =
    let h = runHarmonySearch 200
        a1 = assertRealNear "Harmony search returns 14.2" 14.2 h 0.01
    in makeCaseResult "testHarmony" [a1] 0.4

runSuiteTestHarmonySearchOptical :: TestSuiteResult
runSuiteTestHarmonySearchOptical = makeSuiteResult "TestHarmonySearchOptical" [testHarmony]


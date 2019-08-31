implementation module Etalon.Tests.TestRegeneratorPlacement

/*
 * TestRegeneratorPlacement.icl: 3R optical-electrical-optical regenerator placement heuristics test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestRegeneratorPlacement
import Etalon.Routing.Regenerator


testRegenNecessity :: TestCaseResult
testRegenNecessity =
    let needRegen1 = isRegeneratorRequired 2500.0 2000.0 12.0 14.0
        a1 = assertBool "Regen required when path exceeds reach limit" True needRegen1
        needRegen2 = isRegeneratorRequired 1000.0 2000.0 18.0 14.0
        a2 = assertBool "Regen not required for short high-OSNR path" False needRegen2
    in makeCaseResult "testRegenNecessity" [a1, a2] 0.4


runSuiteTestRegeneratorPlacement :: TestSuiteResult
runSuiteTestRegeneratorPlacement =
    makeSuiteResult "TestRegeneratorPlacement" [testRegenNecessity]

implementation module Etalon.Tests.TestTransatlanticCableUpgrade

/*
 * TestTransatlanticCableUpgrade.icl: Subsea upgrade scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTransatlanticCableUpgrade
import Etalon.Scenarios.TransatlanticCableUpgrade


testUpgrade :: TestCaseResult
testUpgrade =
    let ok = runTransatlanticUpgradeSimulation
        a1 = assertBool "Simulation executes" True ok
    in makeCaseResult "testUpgrade" [a1] 0.4

runSuiteTestTransatlanticCableUpgrade :: TestSuiteResult
runSuiteTestTransatlanticCableUpgrade = makeSuiteResult "TestTransatlanticCableUpgrade" [testUpgrade]


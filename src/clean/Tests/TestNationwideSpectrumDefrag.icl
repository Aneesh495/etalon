implementation module Etalon.Tests.TestNationwideSpectrumDefrag

/*
 * TestNationwideSpectrumDefrag.icl: Defrag scenario verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNationwideSpectrumDefrag
import Etalon.Scenarios.NationwideSpectrumDefrag


testDefrag :: TestCaseResult
testDefrag =
    let ok = runNationwideDefragSimulation
        a1 = assertBool "Simulation executes" True ok
    in makeCaseResult "testDefrag" [a1] 0.4

runSuiteTestNationwideSpectrumDefrag :: TestSuiteResult
runSuiteTestNationwideSpectrumDefrag = makeSuiteResult "TestNationwideSpectrumDefrag" [testDefrag]


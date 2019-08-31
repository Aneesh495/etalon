implementation module Etalon.Tests.TestGoldenSectionSearch

/*
 * TestGoldenSectionSearch.icl: Golden section search verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGoldenSectionSearch
import Etalon.Algorithms.GoldenSectionSearch


testGoldenSection :: TestCaseResult
testGoldenSection =
    let fn x = (x - 2.0) * (x - 2.0)
        opt = findOptimalLaunchPower fn 0.0 4.0 0.01
        a1 = assertRealNear "Finds midpoint near 2.0" 2.0 opt 0.1
    in makeCaseResult "testGoldenSection" [a1] 0.4

runSuiteTestGoldenSectionSearch :: TestSuiteResult
runSuiteTestGoldenSectionSearch = makeSuiteResult "TestGoldenSectionSearch" [testGoldenSection]


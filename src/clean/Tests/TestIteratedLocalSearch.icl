implementation module Etalon.Tests.TestIteratedLocalSearch

/*
 * TestIteratedLocalSearch.icl: ILS optimization verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIteratedLocalSearch
import Etalon.Optimization.IteratedLocalSearch


testIls :: TestCaseResult
testIls =
    let s = runIlsOptimization 100
        a1 = assertRealNear "ILS returns 120.0" 120.0 s 0.01
    in makeCaseResult "testIls" [a1] 0.4

runSuiteTestIteratedLocalSearch :: TestSuiteResult
runSuiteTestIteratedLocalSearch = makeSuiteResult "TestIteratedLocalSearch" [testIls]


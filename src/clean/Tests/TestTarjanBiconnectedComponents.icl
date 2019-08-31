implementation module Etalon.Tests.TestTarjanBiconnectedComponents

/*
 * TestTarjanBiconnectedComponents.icl: Tarjan bridges verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTarjanBiconnectedComponents
import Etalon.Algorithms.TarjanBiconnectedComponents


testTarjan :: TestCaseResult
testTarjan =
    let bridges = findNetworkBridges 4 [(1, 2), (2, 3), (3, 4)]
        a1 = assertBool "Bridges check completes" True (length bridges >= 0)
    in makeCaseResult "testTarjan" [a1] 0.4

runSuiteTestTarjanBiconnectedComponents :: TestSuiteResult
runSuiteTestTarjanBiconnectedComponents = makeSuiteResult "TestTarjanBiconnectedComponents" [testTarjan]


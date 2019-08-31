implementation module Etalon.Tests.TestErlangEngine

/*
 * TestErlangEngine.icl: Erlang-B and Erlang-C blocking models test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestErlangEngine
import Etalon.Simulation.ErlangTrafficEngine


testErlangFormulas :: TestCaseResult
testErlangFormulas =
    let b = computeErlangB 10.0 15
        c = computeErlangC 10.0 15
        a1 = assertBool "Erlang-B blocking is between 0 and 1" True (b > 0.0 && b < 1.0)
        a2 = assertBool "Erlang-C delay probability >= Erlang-B" True (c >= b)
    in makeCaseResult "testErlangFormulas" [a1, a2] 0.4

runSuiteTestErlangEngine :: TestSuiteResult
runSuiteTestErlangEngine = makeSuiteResult "TestErlangEngine" [testErlangFormulas]


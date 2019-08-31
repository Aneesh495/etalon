implementation module Etalon.Tests.TestTabuSearchRetuning

/*
 * TestTabuSearchRetuning.icl: Tabu search recency tenure and aspiration overriding test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTabuSearchRetuning
import Etalon.Optimization.TabuSearch
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph


testTabuSearchTenure :: TestCaseResult
testTabuSearchTenure =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        cfg = defaultTabuConfig
        (ws1, res) = runTabuSearchOptimizer ws cfg
        a1 = assertIntEq "Executed all configured iterations" cfg.maxIterations res.iterationsRun
        a2 = assertBool "Tabu hits prevented cycling" True (res.tabuHitsPrevented > 0)
    in makeCaseResult "testTabuSearchTenure" [a1, a2] 0.6


runSuiteTestTabuSearchRetuning :: TestSuiteResult
runSuiteTestTabuSearchRetuning =
    makeSuiteResult "TestTabuSearchRetuning" [testTabuSearchTenure]

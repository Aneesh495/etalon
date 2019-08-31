implementation module Etalon.Tests.TestMultiLayer

/*
 * TestMultiLayer.icl: L0 and L1 multi-layer grooming graph test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMultiLayer
import Etalon.Topology.MultiLayerGraph


testMultiLayerGraphConstruction :: TestCaseResult
testMultiLayerGraphConstruction =
    let g0 = createMultiLayerGraph
        g1 = addMultiLayerNode g0 1 LayerOpticalL0 101
        g2 = addMultiLayerNode g1 2 LayerOtnL1 101
        g3 = addMultiLayerEdge g2 1 1 2 100.0 True
        a1 = assertIntEq "2 nodes in multilayer graph" 2 (length g3.nodes)
        a2 = assertIntEq "1 edge in multilayer graph" 1 (length g3.edges)
    in makeCaseResult "testMultiLayerGraphConstruction" [a1, a2] 0.4

runSuiteTestMultiLayer :: TestSuiteResult
runSuiteTestMultiLayer = makeSuiteResult "TestMultiLayer" [testMultiLayerGraphConstruction]


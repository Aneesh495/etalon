implementation module Etalon.Tests.TestTopologiesReference

/*
 * TestTopologiesReference.icl: Reference carrier topologies node and link count verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTopologiesReference
import Etalon.Topologies.UsNet
import Etalon.Topologies.PanEuropean
import Etalon.Topologies.JapanBackbone
import Etalon.Topologies.MetroRing


testTopologyDimensions :: TestCaseResult
testTopologyDimensions =
    let us = buildUsNet
        euro = buildPanEuropean
        jpn = buildJapanBackbone
        ring = buildMetroRing
        a1 = assertIntEq "US-Net has 24 nodes" 24 us.nodeCount
        a2 = assertIntEq "US-Net has 43 links" 43 us.linkCount
        a3 = assertIntEq "Pan-European has 28 nodes" 28 euro.nodeCount
        a4 = assertIntEq "Pan-European has 41 links" 41 euro.linkCount
        a5 = assertIntEq "Japan Backbone has 14 nodes" 14 jpn.nodeCount
        a6 = assertIntEq "Japan Backbone has 21 links" 21 jpn.linkCount
        a7 = assertIntEq "Metro Ring has 8 nodes" 8 ring.nodeCount
        a8 = assertIntEq "Metro Ring has 16 links" 16 ring.linkCount
    in makeCaseResult "testTopologyDimensions" [a1, a2, a3, a4, a5, a6, a7, a8] 0.8


runSuiteTestTopologiesReference :: TestSuiteResult
runSuiteTestTopologiesReference =
    makeSuiteResult "TestTopologiesReference" [testTopologyDimensions]

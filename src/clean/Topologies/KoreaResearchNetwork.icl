implementation module Etalon.Topologies.KoreaResearchNetwork

/*
 * KoreaResearchNetwork.icl: Korea Advanced Research Network optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.KoreaResearchNetwork
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

koreaResearchNetworkNodeCount :== 10
koreaResearchNetworkLinkCount :== 20

buildKoreaResearchNetwork :: *OpticalGraph
buildKoreaResearchNetwork =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > 10 = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ (1, 1, 2, 160.0, [6501]),
                (2, 2, 3, 160.0, [6502]),
                (3, 3, 4, 160.0, [6503]),
                (4, 4, 5, 160.0, [6504]),
                (5, 5, 6, 160.0, [6505]),
                (6, 6, 7, 160.0, [6506]),
                (7, 7, 8, 160.0, [6507]),
                (8, 8, 9, 160.0, [6508]),
                (9, 9, 10, 160.0, [6509]),
                (10, 10, 1, 160.0, [6510]),
                (11, 3, 8, 240.0, [6551]),
                (12, 5, 5, 240.0, [6552]),
                (13, 7, 2, 240.0, [6553]),
                (14, 9, 9, 240.0, [6554]),
                (15, 1, 6, 240.0, [6555]),
                (16, 3, 3, 240.0, [6556]),
                (17, 5, 10, 240.0, [6557]),
                (18, 7, 7, 240.0, [6558]),
                (19, 9, 4, 240.0, [6559]),
                (20, 1, 1, 240.0, [6560])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

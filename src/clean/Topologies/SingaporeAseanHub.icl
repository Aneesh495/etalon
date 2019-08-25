implementation module Etalon.Topologies.SingaporeAseanHub

/*
 * SingaporeAseanHub.icl: Singapore ASEAN Hub optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SingaporeAseanHub
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

singaporeAseanHubNodeCount :== 12
singaporeAseanHubLinkCount :== 24

buildSingaporeAseanHub :: *OpticalGraph
buildSingaporeAseanHub =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > 12 = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ (1, 1, 2, 350.0, [6201]),
                (2, 2, 3, 350.0, [6202]),
                (3, 3, 4, 350.0, [6203]),
                (4, 4, 5, 350.0, [6204]),
                (5, 5, 6, 350.0, [6205]),
                (6, 6, 7, 350.0, [6206]),
                (7, 7, 8, 350.0, [6207]),
                (8, 8, 9, 350.0, [6208]),
                (9, 9, 10, 350.0, [6209]),
                (10, 10, 11, 350.0, [6210]),
                (11, 11, 12, 350.0, [6211]),
                (12, 12, 1, 350.0, [6212]),
                (13, 3, 6, 650.0, [6251]),
                (14, 5, 11, 650.0, [6252]),
                (15, 7, 4, 650.0, [6253]),
                (16, 9, 9, 650.0, [6254]),
                (17, 11, 2, 650.0, [6255]),
                (18, 1, 7, 650.0, [6256]),
                (19, 3, 12, 650.0, [6257]),
                (20, 5, 5, 650.0, [6258]),
                (21, 7, 10, 650.0, [6259]),
                (22, 9, 3, 650.0, [6260]),
                (23, 11, 8, 650.0, [6261]),
                (24, 1, 1, 650.0, [6262])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

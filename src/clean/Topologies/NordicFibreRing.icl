implementation module Etalon.Topologies.NordicFibreRing

/*
 * NordicFibreRing.icl: Nordic Fibre Ring optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.NordicFibreRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

nordicFibreRingNodeCount :== 10
nordicFibreRingLinkCount :== 20

buildNordicFibreRing :: *OpticalGraph
buildNordicFibreRing =
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
    linkSpecs = [ (1, 1, 2, 280.0, [6101]),
                (2, 2, 3, 280.0, [6102]),
                (3, 3, 4, 280.0, [6103]),
                (4, 4, 5, 280.0, [6104]),
                (5, 5, 6, 280.0, [6105]),
                (6, 6, 7, 280.0, [6106]),
                (7, 7, 8, 280.0, [6107]),
                (8, 8, 9, 280.0, [6108]),
                (9, 9, 10, 280.0, [6109]),
                (10, 10, 1, 280.0, [6110]),
                (11, 4, 8, 420.0, [6151]),
                (12, 7, 5, 420.0, [6152]),
                (13, 10, 2, 420.0, [6153]),
                (14, 3, 9, 420.0, [6154]),
                (15, 6, 6, 420.0, [6155]),
                (16, 9, 3, 420.0, [6156]),
                (17, 2, 10, 420.0, [6157]),
                (18, 5, 7, 420.0, [6158]),
                (19, 8, 4, 420.0, [6159]),
                (20, 1, 1, 420.0, [6160])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

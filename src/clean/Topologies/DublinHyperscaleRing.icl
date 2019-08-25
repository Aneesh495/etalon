implementation module Etalon.Topologies.DublinHyperscaleRing

/*
 * DublinHyperscaleRing.icl: Dublin Hyperscale Ring optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.DublinHyperscaleRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

dublinHyperscaleRingNodeCount :== 10
dublinHyperscaleRingLinkCount :== 20

buildDublinHyperscaleRing :: *OpticalGraph
buildDublinHyperscaleRing =
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
    linkSpecs = [ (1, 1, 2, 14.0, [7301]),
                (2, 2, 3, 14.0, [7302]),
                (3, 3, 4, 14.0, [7303]),
                (4, 4, 5, 14.0, [7304]),
                (5, 5, 6, 14.0, [7305]),
                (6, 6, 7, 14.0, [7306]),
                (7, 7, 8, 14.0, [7307]),
                (8, 8, 9, 14.0, [7308]),
                (9, 9, 10, 14.0, [7309]),
                (10, 10, 1, 14.0, [7310]),
                (11, 4, 8, 22.0, [7351]),
                (12, 7, 5, 22.0, [7352]),
                (13, 10, 2, 22.0, [7353]),
                (14, 3, 9, 22.0, [7354]),
                (15, 6, 6, 22.0, [7355]),
                (16, 9, 3, 22.0, [7356]),
                (17, 2, 10, 22.0, [7357]),
                (18, 5, 7, 22.0, [7358]),
                (19, 8, 4, 22.0, [7359]),
                (20, 1, 1, 22.0, [7360])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

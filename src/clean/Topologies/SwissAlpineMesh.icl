implementation module Etalon.Topologies.SwissAlpineMesh

/*
 * SwissAlpineMesh.icl: Swiss Alpine Optical Mesh optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SwissAlpineMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

swissAlpineMeshNodeCount :== 8
swissAlpineMeshLinkCount :== 16

buildSwissAlpineMesh :: *OpticalGraph
buildSwissAlpineMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > 8 = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ (1, 1, 2, 85.0, [6301]),
                (2, 2, 3, 85.0, [6302]),
                (3, 3, 4, 85.0, [6303]),
                (4, 4, 5, 85.0, [6304]),
                (5, 5, 6, 85.0, [6305]),
                (6, 6, 7, 85.0, [6306]),
                (7, 7, 8, 85.0, [6307]),
                (8, 8, 1, 85.0, [6308]),
                (9, 4, 6, 120.0, [6351]),
                (10, 7, 3, 120.0, [6352]),
                (11, 2, 8, 120.0, [6353]),
                (12, 5, 5, 120.0, [6354]),
                (13, 8, 2, 120.0, [6355]),
                (14, 3, 7, 120.0, [6356]),
                (15, 6, 4, 120.0, [6357]),
                (16, 1, 1, 120.0, [6358])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

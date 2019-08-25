implementation module Etalon.Topologies.SingaporeDataCenterFabric

/*
 * SingaporeDataCenterFabric.icl: Singapore Hyperscale DCI Fabric optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SingaporeDataCenterFabric
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

singaporeDataCenterFabricNodeCount :== 8
singaporeDataCenterFabricLinkCount :== 16

buildSingaporeDataCenterFabric :: *OpticalGraph
buildSingaporeDataCenterFabric =
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
    linkSpecs = [ (1, 1, 2, 12.0, [7101]),
                (2, 2, 3, 12.0, [7102]),
                (3, 3, 4, 12.0, [7103]),
                (4, 4, 5, 12.0, [7104]),
                (5, 5, 6, 12.0, [7105]),
                (6, 6, 7, 12.0, [7106]),
                (7, 7, 8, 12.0, [7107]),
                (8, 8, 1, 12.0, [7108]),
                (9, 4, 6, 18.0, [7151]),
                (10, 7, 3, 18.0, [7152]),
                (11, 2, 8, 18.0, [7153]),
                (12, 5, 5, 18.0, [7154]),
                (13, 8, 2, 18.0, [7155]),
                (14, 3, 7, 18.0, [7156]),
                (15, 6, 4, 18.0, [7157]),
                (16, 1, 1, 18.0, [7158])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

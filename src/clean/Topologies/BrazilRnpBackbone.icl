implementation module Etalon.Topologies.BrazilRnpBackbone

/*
 * BrazilRnpBackbone.icl: Brazil RNP National Backbone optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.BrazilRnpBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

brazilRnpBackboneNodeCount :== 12
brazilRnpBackboneLinkCount :== 24

buildBrazilRnpBackbone :: *OpticalGraph
buildBrazilRnpBackbone =
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
    linkSpecs = [ (1, 1, 2, 620.0, [6601]),
                (2, 2, 3, 620.0, [6602]),
                (3, 3, 4, 620.0, [6603]),
                (4, 4, 5, 620.0, [6604]),
                (5, 5, 6, 620.0, [6605]),
                (6, 6, 7, 620.0, [6606]),
                (7, 7, 8, 620.0, [6607]),
                (8, 8, 9, 620.0, [6608]),
                (9, 9, 10, 620.0, [6609]),
                (10, 10, 11, 620.0, [6610]),
                (11, 11, 12, 620.0, [6611]),
                (12, 12, 1, 620.0, [6612]),
                (13, 4, 6, 980.0, [6651]),
                (14, 7, 11, 980.0, [6652]),
                (15, 10, 4, 980.0, [6653]),
                (16, 1, 9, 980.0, [6654]),
                (17, 4, 2, 980.0, [6655]),
                (18, 7, 7, 980.0, [6656]),
                (19, 10, 12, 980.0, [6657]),
                (20, 1, 5, 980.0, [6658]),
                (21, 4, 10, 980.0, [6659]),
                (22, 7, 3, 980.0, [6660]),
                (23, 10, 8, 980.0, [6661]),
                (24, 1, 1, 980.0, [6662])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

implementation module Etalon.Topologies.MiddleEastGulfRing

/*
 * MiddleEastGulfRing.icl: Middle East Gulf Optical Ring optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.MiddleEastGulfRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

middleEastGulfRingNodeCount :== 8
middleEastGulfRingLinkCount :== 16

buildMiddleEastGulfRing :: *OpticalGraph
buildMiddleEastGulfRing =
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
    linkSpecs = [ (1, 1, 2, 320.0, [6801]),
                (2, 2, 3, 320.0, [6802]),
                (3, 3, 4, 320.0, [6803]),
                (4, 4, 5, 320.0, [6804]),
                (5, 5, 6, 320.0, [6805]),
                (6, 6, 7, 320.0, [6806]),
                (7, 7, 8, 320.0, [6807]),
                (8, 8, 1, 320.0, [6808]),
                (9, 4, 6, 510.0, [6851]),
                (10, 7, 3, 510.0, [6852]),
                (11, 2, 8, 510.0, [6853]),
                (12, 5, 5, 510.0, [6854]),
                (13, 8, 2, 510.0, [6855]),
                (14, 3, 7, 510.0, [6856]),
                (15, 6, 4, 510.0, [6857]),
                (16, 1, 1, 510.0, [6858])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

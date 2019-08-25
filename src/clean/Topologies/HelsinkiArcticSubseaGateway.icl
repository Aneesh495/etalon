implementation module Etalon.Topologies.HelsinkiArcticSubseaGateway

/*
 * HelsinkiArcticSubseaGateway.icl: Helsinki Arctic Subsea Optical Gateway optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.HelsinkiArcticSubseaGateway
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

helsinkiArcticSubseaGatewayNodeCount :== 8
helsinkiArcticSubseaGatewayLinkCount :== 16

buildHelsinkiArcticSubseaGateway :: *OpticalGraph
buildHelsinkiArcticSubseaGateway =
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
    linkSpecs = [ (1, 1, 2, 90.0, [7501]),
                (2, 2, 3, 90.0, [7502]),
                (3, 3, 4, 90.0, [7503]),
                (4, 4, 5, 90.0, [7504]),
                (5, 5, 6, 90.0, [7505]),
                (6, 6, 7, 90.0, [7506]),
                (7, 7, 8, 90.0, [7507]),
                (8, 8, 1, 90.0, [7508]),
                (9, 4, 6, 150.0, [7551]),
                (10, 7, 3, 150.0, [7552]),
                (11, 2, 8, 150.0, [7553]),
                (12, 5, 5, 150.0, [7554]),
                (13, 8, 2, 150.0, [7555]),
                (14, 3, 7, 150.0, [7556]),
                (15, 6, 4, 150.0, [7557]),
                (16, 1, 1, 150.0, [7558])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

implementation module Etalon.Topologies.AshburnNorthernVirginiaCorridor

/*
 * AshburnNorthernVirginiaCorridor.icl: Ashburn Northern Virginia Cloud Corridor optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.AshburnNorthernVirginiaCorridor
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

ashburnNorthernVirginiaCorridorNodeCount :== 12
ashburnNorthernVirginiaCorridorLinkCount :== 24

buildAshburnNorthernVirginiaCorridor :: *OpticalGraph
buildAshburnNorthernVirginiaCorridor =
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
    linkSpecs = [ (1, 1, 2, 15.0, [7201]),
                (2, 2, 3, 15.0, [7202]),
                (3, 3, 4, 15.0, [7203]),
                (4, 4, 5, 15.0, [7204]),
                (5, 5, 6, 15.0, [7205]),
                (6, 6, 7, 15.0, [7206]),
                (7, 7, 8, 15.0, [7207]),
                (8, 8, 9, 15.0, [7208]),
                (9, 9, 10, 15.0, [7209]),
                (10, 10, 11, 15.0, [7210]),
                (11, 11, 12, 15.0, [7211]),
                (12, 12, 1, 15.0, [7212]),
                (13, 3, 6, 28.0, [7251]),
                (14, 5, 11, 28.0, [7252]),
                (15, 7, 4, 28.0, [7253]),
                (16, 9, 9, 28.0, [7254]),
                (17, 11, 2, 28.0, [7255]),
                (18, 1, 7, 28.0, [7256]),
                (19, 3, 12, 28.0, [7257]),
                (20, 5, 5, 28.0, [7258]),
                (21, 7, 10, 28.0, [7259]),
                (22, 9, 3, 28.0, [7260]),
                (23, 11, 8, 28.0, [7261]),
                (24, 1, 1, 28.0, [7262])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

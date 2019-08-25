implementation module Etalon.Topologies.TaiwanSemiconductorCorridor

/*
 * TaiwanSemiconductorCorridor.icl: Taiwan Hsinchu Science Park Optical Corridor optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.TaiwanSemiconductorCorridor
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

taiwanSemiconductorCorridorNodeCount :== 10
taiwanSemiconductorCorridorLinkCount :== 20

buildTaiwanSemiconductorCorridor :: *OpticalGraph
buildTaiwanSemiconductorCorridor =
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
    linkSpecs = [ (1, 1, 2, 35.0, [7401]),
                (2, 2, 3, 35.0, [7402]),
                (3, 3, 4, 35.0, [7403]),
                (4, 4, 5, 35.0, [7404]),
                (5, 5, 6, 35.0, [7405]),
                (6, 6, 7, 35.0, [7406]),
                (7, 7, 8, 35.0, [7407]),
                (8, 8, 9, 35.0, [7408]),
                (9, 9, 10, 35.0, [7409]),
                (10, 10, 1, 35.0, [7410]),
                (11, 3, 6, 65.0, [7451]),
                (12, 5, 1, 65.0, [7452]),
                (13, 7, 6, 65.0, [7453]),
                (14, 9, 1, 65.0, [7454]),
                (15, 1, 6, 65.0, [7455]),
                (16, 3, 1, 65.0, [7456]),
                (17, 5, 6, 65.0, [7457]),
                (18, 7, 1, 65.0, [7458]),
                (19, 9, 6, 65.0, [7459]),
                (20, 1, 1, 65.0, [7460])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

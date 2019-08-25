implementation module Etalon.Topologies.IndiaNationalTerabitGrid

/*
 * IndiaNationalTerabitGrid.icl: India National Terabit Grid optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.IndiaNationalTerabitGrid
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

indiaNationalTerabitGridNodeCount :== 14
indiaNationalTerabitGridLinkCount :== 28

buildIndiaNationalTerabitGrid :: *OpticalGraph
buildIndiaNationalTerabitGrid =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > 14 = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ (1, 1, 2, 480.0, [6401]),
                (2, 2, 3, 480.0, [6402]),
                (3, 3, 4, 480.0, [6403]),
                (4, 4, 5, 480.0, [6404]),
                (5, 5, 6, 480.0, [6405]),
                (6, 6, 7, 480.0, [6406]),
                (7, 7, 8, 480.0, [6407]),
                (8, 8, 9, 480.0, [6408]),
                (9, 9, 10, 480.0, [6409]),
                (10, 10, 11, 480.0, [6410]),
                (11, 11, 12, 480.0, [6411]),
                (12, 12, 13, 480.0, [6412]),
                (13, 13, 14, 480.0, [6413]),
                (14, 14, 1, 480.0, [6414]),
                (15, 4, 6, 850.0, [6451]),
                (16, 7, 11, 850.0, [6452]),
                (17, 10, 2, 850.0, [6453]),
                (18, 13, 7, 850.0, [6454]),
                (19, 2, 12, 850.0, [6455]),
                (20, 5, 3, 850.0, [6456]),
                (21, 8, 8, 850.0, [6457]),
                (22, 11, 13, 850.0, [6458]),
                (23, 14, 4, 850.0, [6459]),
                (24, 3, 9, 850.0, [6460]),
                (25, 6, 14, 850.0, [6461]),
                (26, 9, 5, 850.0, [6462]),
                (27, 12, 10, 850.0, [6463]),
                (28, 1, 1, 850.0, [6464])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

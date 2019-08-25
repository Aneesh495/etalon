implementation module Etalon.Topologies.BayAreaSiliconRing

/*
 * BayAreaSiliconRing.icl: San Francisco Bay Area optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.BayAreaSiliconRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

bayAreaSiliconRingNodeCount :== 16
bayAreaSiliconRingLinkCount :== 30

buildBayAreaSiliconRing :: *OpticalGraph
buildBayAreaSiliconRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > bayAreaSiliconRingNodeCount = g
        = let node = createCdcRoadmNode idx ("BayAreaSiliconRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 22.0, [5401]),
                (2, 2, 3, 22.0, [5402]),
                (3, 3, 4, 22.0, [5403]),
                (4, 4, 5, 22.0, [5404]),
                (5, 5, 6, 22.0, [5405]),
                (6, 6, 7, 22.0, [5406]),
                (7, 7, 8, 22.0, [5407]),
                (8, 8, 9, 22.0, [5408]),
                (9, 9, 10, 22.0, [5409]),
                (10, 10, 11, 22.0, [5410]),
                (11, 11, 12, 22.0, [5411]),
                (12, 12, 13, 22.0, [5412]),
                (13, 13, 14, 22.0, [5413]),
                (14, 14, 15, 22.0, [5414]),
                (15, 15, 16, 22.0, [5415]),
                (16, 16, 1, 22.0, [5416]),
                (17, 4, 6, 45.0, [5451]),
                (18, 7, 11, 45.0, [5452]),
                (19, 10, 16, 45.0, [5453]),
                (20, 13, 5, 45.0, [5454]),
                (21, 16, 10, 45.0, [5455]),
                (22, 3, 15, 45.0, [5456]),
                (23, 6, 4, 45.0, [5457]),
                (24, 9, 9, 45.0, [5458]),
                (25, 12, 14, 45.0, [5459]),
                (26, 15, 3, 45.0, [5460]),
                (27, 2, 8, 45.0, [5461]),
                (28, 5, 13, 45.0, [5462]),
                (29, 8, 2, 45.0, [5463]),
                (30, 11, 7, 45.0, [5464])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

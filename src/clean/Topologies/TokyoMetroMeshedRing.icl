implementation module Etalon.Topologies.TokyoMetroMeshedRing

/*
 * TokyoMetroMeshedRing.icl: Tokyo Metro optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.TokyoMetroMeshedRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

tokyoMetroMeshedRingNodeCount :== 16
tokyoMetroMeshedRingLinkCount :== 32

buildTokyoMetroMeshedRing :: *OpticalGraph
buildTokyoMetroMeshedRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > tokyoMetroMeshedRingNodeCount = g
        = let node = createCdcRoadmNode idx ("TokyoMetroMeshedRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 15.0, [5001]),
                (2, 2, 3, 15.0, [5002]),
                (3, 3, 4, 15.0, [5003]),
                (4, 4, 5, 15.0, [5004]),
                (5, 5, 6, 15.0, [5005]),
                (6, 6, 7, 15.0, [5006]),
                (7, 7, 8, 15.0, [5007]),
                (8, 8, 9, 15.0, [5008]),
                (9, 9, 10, 15.0, [5009]),
                (10, 10, 11, 15.0, [5010]),
                (11, 11, 12, 15.0, [5011]),
                (12, 12, 13, 15.0, [5012]),
                (13, 13, 14, 15.0, [5013]),
                (14, 14, 15, 15.0, [5014]),
                (15, 15, 16, 15.0, [5015]),
                (16, 16, 1, 15.0, [5016]),
                (17, 4, 6, 28.0, [5051]),
                (18, 7, 11, 28.0, [5052]),
                (19, 10, 16, 28.0, [5053]),
                (20, 13, 5, 28.0, [5054]),
                (21, 16, 10, 28.0, [5055]),
                (22, 3, 15, 28.0, [5056]),
                (23, 6, 4, 28.0, [5057]),
                (24, 9, 9, 28.0, [5058]),
                (25, 12, 14, 28.0, [5059]),
                (26, 15, 3, 28.0, [5060]),
                (27, 2, 8, 28.0, [5061]),
                (28, 5, 13, 28.0, [5062]),
                (29, 8, 2, 28.0, [5063]),
                (30, 11, 7, 28.0, [5064]),
                (31, 14, 12, 28.0, [5065]),
                (32, 1, 1, 28.0, [5066])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

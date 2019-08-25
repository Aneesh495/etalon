implementation module Etalon.Topologies.HongKongHarborRing

/*
 * HongKongHarborRing.icl: Hong Kong Harbor optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.HongKongHarborRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

hongKongHarborRingNodeCount :== 10
hongKongHarborRingLinkCount :== 20

buildHongKongHarborRing :: *OpticalGraph
buildHongKongHarborRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > hongKongHarborRingNodeCount = g
        = let node = createCdcRoadmNode idx ("HongKongHarborRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 7.5, [5701]),
                (2, 2, 3, 7.5, [5702]),
                (3, 3, 4, 7.5, [5703]),
                (4, 4, 5, 7.5, [5704]),
                (5, 5, 6, 7.5, [5705]),
                (6, 6, 7, 7.5, [5706]),
                (7, 7, 8, 7.5, [5707]),
                (8, 8, 9, 7.5, [5708]),
                (9, 9, 10, 7.5, [5709]),
                (10, 10, 1, 7.5, [5710]),
                (11, 4, 5, 15.0, [5751]),
                (12, 7, 9, 15.0, [5752]),
                (13, 10, 3, 15.0, [5753]),
                (14, 3, 7, 15.0, [5754]),
                (15, 6, 1, 15.0, [5755]),
                (16, 9, 5, 15.0, [5756]),
                (17, 2, 9, 15.0, [5757]),
                (18, 5, 3, 15.0, [5758]),
                (19, 8, 7, 15.0, [5759]),
                (20, 1, 1, 15.0, [5760])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

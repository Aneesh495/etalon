implementation module Etalon.Topologies.Abilene

/*
 * Abilene.icl: Abilene topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.Abilene
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

abileneNodeCount :== 12
abileneLinkCount :== 15

buildAbilene :: *OpticalGraph
buildAbilene =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > abileneNodeCount = g
        = let node = createCdcRoadmNode idx ("Abilene-" +++ toString idx) 3 16
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 850.0, [701]),
                (2, 2, 3, 1100.0, [702]),
                (3, 3, 4, 950.0, [703]),
                (4, 4, 5, 1200.0, [704]),
                (5, 5, 6, 750.0, [705]),
                (6, 6, 7, 890.0, [706]),
                (7, 7, 8, 650.0, [707]),
                (8, 8, 9, 920.0, [708]),
                (9, 9, 10, 780.0, [709]),
                (10, 10, 11, 840.0, [710]),
                (11, 11, 12, 1050.0, [711]),
                (12, 12, 1, 1300.0, [712]),
                (13, 2, 7, 1450.0, [713]),
                (14, 4, 9, 1600.0, [714]),
                (15, 5, 11, 1350.0, [715])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

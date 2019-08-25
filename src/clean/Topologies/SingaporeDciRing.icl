implementation module Etalon.Topologies.SingaporeDciRing

/*
 * SingaporeDciRing.icl: Singapore optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SingaporeDciRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

singaporeDciRingNodeCount :== 10
singaporeDciRingLinkCount :== 15

buildSingaporeDciRing :: *OpticalGraph
buildSingaporeDciRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > singaporeDciRingNodeCount = g
        = let node = createCdcRoadmNode idx ("SingaporeDciRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 12.0, [4501]),
                (2, 2, 3, 12.0, [4502]),
                (3, 3, 4, 12.0, [4503]),
                (4, 4, 5, 12.0, [4504]),
                (5, 5, 6, 12.0, [4505]),
                (6, 6, 7, 12.0, [4506]),
                (7, 7, 8, 12.0, [4507]),
                (8, 8, 9, 12.0, [4508]),
                (9, 9, 10, 12.0, [4509]),
                (10, 10, 1, 12.0, [4510]),
                (11, 3, 5, 22.0, [4551]),
                (12, 5, 9, 22.0, [4552]),
                (13, 7, 3, 22.0, [4553]),
                (14, 9, 7, 22.0, [4554]),
                (15, 1, 1, 22.0, [4555])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

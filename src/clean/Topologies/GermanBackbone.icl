implementation module Etalon.Topologies.GermanBackbone

/*
 * GermanBackbone.icl: German backbone topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.GermanBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

germanNodeCount :== 17
germanLinkCount :== 26

buildGermanBackbone :: *OpticalGraph
buildGermanBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > germanNodeCount = g
        = let node = createCdcRoadmNode idx ("DE-Node-" +++ toString idx) 4 24
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 280.0, [501]),
                (2, 2, 3, 190.0, [502]),
                (3, 3, 4, 150.0, [503]),
                (4, 4, 5, 220.0, [504]),
                (5, 5, 6, 180.0, [505]),
                (6, 6, 7, 310.0, [506]),
                (7, 7, 8, 140.0, [507]),
                (8, 8, 9, 210.0, [508]),
                (9, 9, 10, 160.0, [509]),
                (10, 10, 11, 200.0, [510]),
                (11, 11, 12, 130.0, [511]),
                (12, 12, 13, 250.0, [512]),
                (13, 13, 14, 170.0, [513]),
                (14, 14, 15, 230.0, [514]),
                (15, 15, 16, 190.0, [515]),
                (16, 16, 17, 120.0, [516]),
                (17, 1, 17, 290.0, [517]),
                (18, 2, 8, 340.0, [518]),
                (19, 3, 9, 270.0, [519]),
                (20, 4, 12, 310.0, [520]),
                (21, 5, 13, 260.0, [521]),
                (22, 6, 14, 280.0, [522]),
                (23, 7, 15, 300.0, [523]),
                (24, 8, 16, 220.0, [524]),
                (25, 9, 17, 240.0, [525]),
                (26, 10, 14, 320.0, [526])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

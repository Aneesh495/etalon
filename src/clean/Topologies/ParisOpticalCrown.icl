implementation module Etalon.Topologies.ParisOpticalCrown

/*
 * ParisOpticalCrown.icl: Paris Metro optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.ParisOpticalCrown
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

parisOpticalCrownNodeCount :== 14
parisOpticalCrownLinkCount :== 28

buildParisOpticalCrown :: *OpticalGraph
buildParisOpticalCrown =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > parisOpticalCrownNodeCount = g
        = let node = createCdcRoadmNode idx ("ParisOpticalCrown-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 14.0, [5201]),
                (2, 2, 3, 14.0, [5202]),
                (3, 3, 4, 14.0, [5203]),
                (4, 4, 5, 14.0, [5204]),
                (5, 5, 6, 14.0, [5205]),
                (6, 6, 7, 14.0, [5206]),
                (7, 7, 8, 14.0, [5207]),
                (8, 8, 9, 14.0, [5208]),
                (9, 9, 10, 14.0, [5209]),
                (10, 10, 11, 14.0, [5210]),
                (11, 11, 12, 14.0, [5211]),
                (12, 12, 13, 14.0, [5212]),
                (13, 13, 14, 14.0, [5213]),
                (14, 14, 1, 14.0, [5214]),
                (15, 4, 6, 25.0, [5251]),
                (16, 7, 11, 25.0, [5252]),
                (17, 10, 2, 25.0, [5253]),
                (18, 13, 7, 25.0, [5254]),
                (19, 2, 12, 25.0, [5255]),
                (20, 5, 3, 25.0, [5256]),
                (21, 8, 8, 25.0, [5257]),
                (22, 11, 13, 25.0, [5258]),
                (23, 14, 4, 25.0, [5259]),
                (24, 3, 9, 25.0, [5260]),
                (25, 6, 14, 25.0, [5261]),
                (26, 9, 5, 25.0, [5262]),
                (27, 12, 10, 25.0, [5263]),
                (28, 1, 1, 25.0, [5264])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

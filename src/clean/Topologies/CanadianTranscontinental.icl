implementation module Etalon.Topologies.CanadianTranscontinental

/*
 * CanadianTranscontinental.icl: Canada optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.CanadianTranscontinental
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

canadianTranscontinentalNodeCount :== 20
canadianTranscontinentalLinkCount :== 28

buildCanadianTranscontinental :: *OpticalGraph
buildCanadianTranscontinental =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > canadianTranscontinentalNodeCount = g
        = let node = createCdcRoadmNode idx ("CanadianTranscontinental-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 450.0, [4001]),
                (2, 2, 3, 450.0, [4002]),
                (3, 3, 4, 450.0, [4003]),
                (4, 4, 5, 450.0, [4004]),
                (5, 5, 6, 450.0, [4005]),
                (6, 6, 7, 450.0, [4006]),
                (7, 7, 8, 450.0, [4007]),
                (8, 8, 9, 450.0, [4008]),
                (9, 9, 10, 450.0, [4009]),
                (10, 10, 11, 450.0, [4010]),
                (11, 11, 12, 450.0, [4011]),
                (12, 12, 13, 450.0, [4012]),
                (13, 13, 14, 450.0, [4013]),
                (14, 14, 15, 450.0, [4014]),
                (15, 15, 16, 450.0, [4015]),
                (16, 16, 17, 450.0, [4016]),
                (17, 17, 18, 450.0, [4017]),
                (18, 18, 19, 450.0, [4018]),
                (19, 19, 20, 450.0, [4019]),
                (20, 20, 1, 450.0, [4020]),
                (21, 4, 8, 890.0, [4051]),
                (22, 7, 15, 890.0, [4052]),
                (23, 10, 2, 890.0, [4053]),
                (24, 13, 9, 890.0, [4054]),
                (25, 16, 16, 890.0, [4055]),
                (26, 19, 3, 890.0, [4056]),
                (27, 2, 10, 890.0, [4057]),
                (28, 5, 17, 890.0, [4058])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

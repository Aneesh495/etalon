implementation module Etalon.Topologies.KoreanCoreMesh

/*
 * KoreanCoreMesh.icl: South Korea optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.KoreanCoreMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

koreanCoreMeshNodeCount :== 12
koreanCoreMeshLinkCount :== 18

buildKoreanCoreMesh :: *OpticalGraph
buildKoreanCoreMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > koreanCoreMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("KoreanCoreMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 85.0, [3901]),
                (2, 2, 3, 85.0, [3902]),
                (3, 3, 4, 85.0, [3903]),
                (4, 4, 5, 85.0, [3904]),
                (5, 5, 6, 85.0, [3905]),
                (6, 6, 7, 85.0, [3906]),
                (7, 7, 8, 85.0, [3907]),
                (8, 8, 9, 85.0, [3908]),
                (9, 9, 10, 85.0, [3909]),
                (10, 10, 11, 85.0, [3910]),
                (11, 11, 12, 85.0, [3911]),
                (12, 12, 1, 85.0, [3912]),
                (13, 4, 8, 170.0, [3951]),
                (14, 7, 3, 170.0, [3952]),
                (15, 10, 10, 170.0, [3953]),
                (16, 1, 5, 170.0, [3954]),
                (17, 4, 12, 170.0, [3955]),
                (18, 7, 7, 170.0, [3956])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

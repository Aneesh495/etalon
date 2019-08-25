implementation module Etalon.Topologies.ItalyGarrMesh

/*
 * ItalyGarrMesh.icl: Italy optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.ItalyGarrMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

italyGarrMeshNodeCount :== 24
italyGarrMeshLinkCount :== 34

buildItalyGarrMesh :: *OpticalGraph
buildItalyGarrMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > italyGarrMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("ItalyGarrMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 160.0, [4201]),
                (2, 2, 3, 160.0, [4202]),
                (3, 3, 4, 160.0, [4203]),
                (4, 4, 5, 160.0, [4204]),
                (5, 5, 6, 160.0, [4205]),
                (6, 6, 7, 160.0, [4206]),
                (7, 7, 8, 160.0, [4207]),
                (8, 8, 9, 160.0, [4208]),
                (9, 9, 10, 160.0, [4209]),
                (10, 10, 11, 160.0, [4210]),
                (11, 11, 12, 160.0, [4211]),
                (12, 12, 13, 160.0, [4212]),
                (13, 13, 14, 160.0, [4213]),
                (14, 14, 15, 160.0, [4214]),
                (15, 15, 16, 160.0, [4215]),
                (16, 16, 17, 160.0, [4216]),
                (17, 17, 18, 160.0, [4217]),
                (18, 18, 19, 160.0, [4218]),
                (19, 19, 20, 160.0, [4219]),
                (20, 20, 21, 160.0, [4220]),
                (21, 21, 22, 160.0, [4221]),
                (22, 22, 23, 160.0, [4222]),
                (23, 23, 24, 160.0, [4223]),
                (24, 24, 1, 160.0, [4224]),
                (25, 6, 10, 340.0, [4251]),
                (26, 11, 19, 340.0, [4252]),
                (27, 16, 4, 340.0, [4253]),
                (28, 21, 13, 340.0, [4254]),
                (29, 2, 22, 340.0, [4255]),
                (30, 7, 7, 340.0, [4256]),
                (31, 12, 16, 340.0, [4257]),
                (32, 17, 1, 340.0, [4258]),
                (33, 22, 10, 340.0, [4259]),
                (34, 3, 19, 340.0, [4260])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

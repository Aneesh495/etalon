implementation module Etalon.Topologies.SeoulGangnamMesh

/*
 * SeoulGangnamMesh.icl: Seoul Gangnam optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SeoulGangnamMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

seoulGangnamMeshNodeCount :== 14
seoulGangnamMeshLinkCount :== 26

buildSeoulGangnamMesh :: *OpticalGraph
buildSeoulGangnamMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > seoulGangnamMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("SeoulGangnamMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 11.0, [5801]),
                (2, 2, 3, 11.0, [5802]),
                (3, 3, 4, 11.0, [5803]),
                (4, 4, 5, 11.0, [5804]),
                (5, 5, 6, 11.0, [5805]),
                (6, 6, 7, 11.0, [5806]),
                (7, 7, 8, 11.0, [5807]),
                (8, 8, 9, 11.0, [5808]),
                (9, 9, 10, 11.0, [5809]),
                (10, 10, 11, 11.0, [5810]),
                (11, 11, 12, 11.0, [5811]),
                (12, 12, 13, 11.0, [5812]),
                (13, 13, 14, 11.0, [5813]),
                (14, 14, 1, 11.0, [5814]),
                (15, 4, 6, 21.0, [5851]),
                (16, 7, 11, 21.0, [5852]),
                (17, 10, 2, 21.0, [5853]),
                (18, 13, 7, 21.0, [5854]),
                (19, 2, 12, 21.0, [5855]),
                (20, 5, 3, 21.0, [5856]),
                (21, 8, 8, 21.0, [5857]),
                (22, 11, 13, 21.0, [5858]),
                (23, 14, 4, 21.0, [5859]),
                (24, 3, 9, 21.0, [5860]),
                (25, 6, 14, 21.0, [5861]),
                (26, 9, 5, 21.0, [5862])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

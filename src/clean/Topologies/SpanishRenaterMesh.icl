implementation module Etalon.Topologies.SpanishRenaterMesh

/*
 * SpanishRenaterMesh.icl: Spain optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SpanishRenaterMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

spanishRenaterMeshNodeCount :== 22
spanishRenaterMeshLinkCount :== 32

buildSpanishRenaterMesh :: *OpticalGraph
buildSpanishRenaterMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > spanishRenaterMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("SpanishRenaterMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 180.0, [4301]),
                (2, 2, 3, 180.0, [4302]),
                (3, 3, 4, 180.0, [4303]),
                (4, 4, 5, 180.0, [4304]),
                (5, 5, 6, 180.0, [4305]),
                (6, 6, 7, 180.0, [4306]),
                (7, 7, 8, 180.0, [4307]),
                (8, 8, 9, 180.0, [4308]),
                (9, 9, 10, 180.0, [4309]),
                (10, 10, 11, 180.0, [4310]),
                (11, 11, 12, 180.0, [4311]),
                (12, 12, 13, 180.0, [4312]),
                (13, 13, 14, 180.0, [4313]),
                (14, 14, 15, 180.0, [4314]),
                (15, 15, 16, 180.0, [4315]),
                (16, 16, 17, 180.0, [4316]),
                (17, 17, 18, 180.0, [4317]),
                (18, 18, 19, 180.0, [4318]),
                (19, 19, 20, 180.0, [4319]),
                (20, 20, 21, 180.0, [4320]),
                (21, 21, 22, 180.0, [4321]),
                (22, 22, 1, 180.0, [4322]),
                (23, 4, 8, 390.0, [4351]),
                (24, 7, 15, 390.0, [4352]),
                (25, 10, 22, 390.0, [4353]),
                (26, 13, 7, 390.0, [4354]),
                (27, 16, 14, 390.0, [4355]),
                (28, 19, 21, 390.0, [4356]),
                (29, 22, 6, 390.0, [4357]),
                (30, 3, 13, 390.0, [4358]),
                (31, 6, 20, 390.0, [4359]),
                (32, 9, 5, 390.0, [4360])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

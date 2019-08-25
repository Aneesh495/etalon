implementation module Etalon.Topologies.FrankfurtDeCixMesh

/*
 * FrankfurtDeCixMesh.icl: Frankfurt DE-CIX optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.FrankfurtDeCixMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

frankfurtDeCixMeshNodeCount :== 12
frankfurtDeCixMeshLinkCount :== 24

buildFrankfurtDeCixMesh :: *OpticalGraph
buildFrankfurtDeCixMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > frankfurtDeCixMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("FrankfurtDeCixMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 10.0, [5501]),
                (2, 2, 3, 10.0, [5502]),
                (3, 3, 4, 10.0, [5503]),
                (4, 4, 5, 10.0, [5504]),
                (5, 5, 6, 10.0, [5505]),
                (6, 6, 7, 10.0, [5506]),
                (7, 7, 8, 10.0, [5507]),
                (8, 8, 9, 10.0, [5508]),
                (9, 9, 10, 10.0, [5509]),
                (10, 10, 11, 10.0, [5510]),
                (11, 11, 12, 10.0, [5511]),
                (12, 12, 1, 10.0, [5512]),
                (13, 3, 6, 20.0, [5551]),
                (14, 5, 11, 20.0, [5552]),
                (15, 7, 4, 20.0, [5553]),
                (16, 9, 9, 20.0, [5554]),
                (17, 11, 2, 20.0, [5555]),
                (18, 1, 7, 20.0, [5556]),
                (19, 3, 12, 20.0, [5557]),
                (20, 5, 5, 20.0, [5558]),
                (21, 7, 10, 20.0, [5559]),
                (22, 9, 3, 20.0, [5560]),
                (23, 11, 8, 20.0, [5561]),
                (24, 1, 1, 20.0, [5562])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

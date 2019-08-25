implementation module Etalon.Topologies.NordicMesh

/*
 * NordicMesh.icl: Nordic (Scandinavia) optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.NordicMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

nordicMeshNodeCount :== 20
nordicMeshLinkCount :== 30

buildNordicMesh :: *OpticalGraph
buildNordicMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > nordicMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("NordicMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 210.0, [3501]),
                (2, 2, 3, 210.0, [3502]),
                (3, 3, 4, 210.0, [3503]),
                (4, 4, 5, 210.0, [3504]),
                (5, 5, 6, 210.0, [3505]),
                (6, 6, 7, 210.0, [3506]),
                (7, 7, 8, 210.0, [3507]),
                (8, 8, 9, 210.0, [3508]),
                (9, 9, 10, 210.0, [3509]),
                (10, 10, 11, 210.0, [3510]),
                (11, 11, 12, 210.0, [3511]),
                (12, 12, 13, 210.0, [3512]),
                (13, 13, 14, 210.0, [3513]),
                (14, 14, 15, 210.0, [3514]),
                (15, 15, 16, 210.0, [3515]),
                (16, 16, 17, 210.0, [3516]),
                (17, 17, 18, 210.0, [3517]),
                (18, 18, 19, 210.0, [3518]),
                (19, 19, 20, 210.0, [3519]),
                (20, 20, 1, 210.0, [3520]),
                (21, 4, 8, 420.0, [3551]),
                (22, 7, 15, 420.0, [3552]),
                (23, 10, 2, 420.0, [3553]),
                (24, 13, 9, 420.0, [3554]),
                (25, 16, 16, 420.0, [3555]),
                (26, 19, 3, 420.0, [3556]),
                (27, 2, 10, 420.0, [3557]),
                (28, 5, 17, 420.0, [3558]),
                (29, 8, 4, 420.0, [3559]),
                (30, 11, 11, 420.0, [3560])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

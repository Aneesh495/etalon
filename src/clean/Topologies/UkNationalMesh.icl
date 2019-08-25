implementation module Etalon.Topologies.UkNationalMesh

/*
 * UkNationalMesh.icl: United Kingdom optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.UkNationalMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

ukNationalMeshNodeCount :== 22
ukNationalMeshLinkCount :== 32

buildUkNationalMesh :: *OpticalGraph
buildUkNationalMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > ukNationalMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("UkNationalMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 140.0, [3601]),
                (2, 2, 3, 140.0, [3602]),
                (3, 3, 4, 140.0, [3603]),
                (4, 4, 5, 140.0, [3604]),
                (5, 5, 6, 140.0, [3605]),
                (6, 6, 7, 140.0, [3606]),
                (7, 7, 8, 140.0, [3607]),
                (8, 8, 9, 140.0, [3608]),
                (9, 9, 10, 140.0, [3609]),
                (10, 10, 11, 140.0, [3610]),
                (11, 11, 12, 140.0, [3611]),
                (12, 12, 13, 140.0, [3612]),
                (13, 13, 14, 140.0, [3613]),
                (14, 14, 15, 140.0, [3614]),
                (15, 15, 16, 140.0, [3615]),
                (16, 16, 17, 140.0, [3616]),
                (17, 17, 18, 140.0, [3617]),
                (18, 18, 19, 140.0, [3618]),
                (19, 19, 20, 140.0, [3619]),
                (20, 20, 21, 140.0, [3620]),
                (21, 21, 22, 140.0, [3621]),
                (22, 22, 1, 140.0, [3622]),
                (23, 5, 10, 280.0, [3651]),
                (24, 9, 19, 280.0, [3652]),
                (25, 13, 6, 280.0, [3653]),
                (26, 17, 15, 280.0, [3654]),
                (27, 21, 2, 280.0, [3655]),
                (28, 3, 11, 280.0, [3656]),
                (29, 7, 20, 280.0, [3657]),
                (30, 11, 7, 280.0, [3658]),
                (31, 15, 16, 280.0, [3659]),
                (32, 19, 3, 280.0, [3660])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

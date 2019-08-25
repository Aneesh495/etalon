implementation module Etalon.Topologies.SwissCoreMesh

/*
 * SwissCoreMesh.icl: Switzerland optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SwissCoreMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

swissCoreMeshNodeCount :== 14
swissCoreMeshLinkCount :== 20

buildSwissCoreMesh :: *OpticalGraph
buildSwissCoreMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > swissCoreMeshNodeCount = g
        = let node = createCdcRoadmNode idx ("SwissCoreMesh-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 75.0, [4401]),
                (2, 2, 3, 75.0, [4402]),
                (3, 3, 4, 75.0, [4403]),
                (4, 4, 5, 75.0, [4404]),
                (5, 5, 6, 75.0, [4405]),
                (6, 6, 7, 75.0, [4406]),
                (7, 7, 8, 75.0, [4407]),
                (8, 8, 9, 75.0, [4408]),
                (9, 9, 10, 75.0, [4409]),
                (10, 10, 11, 75.0, [4410]),
                (11, 11, 12, 75.0, [4411]),
                (12, 12, 13, 75.0, [4412]),
                (13, 13, 14, 75.0, [4413]),
                (14, 14, 1, 75.0, [4414]),
                (15, 4, 6, 130.0, [4451]),
                (16, 7, 11, 130.0, [4452]),
                (17, 10, 2, 130.0, [4453]),
                (18, 13, 7, 130.0, [4454]),
                (19, 2, 12, 130.0, [4455]),
                (20, 5, 3, 130.0, [4456])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

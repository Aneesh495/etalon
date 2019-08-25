implementation module Etalon.Topologies.AmsterdamAmsIxCore

/*
 * AmsterdamAmsIxCore.icl: Amsterdam AMS-IX optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.AmsterdamAmsIxCore
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

amsterdamAmsIxCoreNodeCount :== 12
amsterdamAmsIxCoreLinkCount :== 24

buildAmsterdamAmsIxCore :: *OpticalGraph
buildAmsterdamAmsIxCore =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > amsterdamAmsIxCoreNodeCount = g
        = let node = createCdcRoadmNode idx ("AmsterdamAmsIxCore-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 9.0, [5601]),
                (2, 2, 3, 9.0, [5602]),
                (3, 3, 4, 9.0, [5603]),
                (4, 4, 5, 9.0, [5604]),
                (5, 5, 6, 9.0, [5605]),
                (6, 6, 7, 9.0, [5606]),
                (7, 7, 8, 9.0, [5607]),
                (8, 8, 9, 9.0, [5608]),
                (9, 9, 10, 9.0, [5609]),
                (10, 10, 11, 9.0, [5610]),
                (11, 11, 12, 9.0, [5611]),
                (12, 12, 1, 9.0, [5612]),
                (13, 3, 6, 19.0, [5651]),
                (14, 5, 11, 19.0, [5652]),
                (15, 7, 4, 19.0, [5653]),
                (16, 9, 9, 19.0, [5654]),
                (17, 11, 2, 19.0, [5655]),
                (18, 1, 7, 19.0, [5656]),
                (19, 3, 12, 19.0, [5657]),
                (20, 5, 5, 19.0, [5658]),
                (21, 7, 10, 19.0, [5659]),
                (22, 9, 3, 19.0, [5660]),
                (23, 11, 8, 19.0, [5661]),
                (24, 1, 1, 19.0, [5662])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

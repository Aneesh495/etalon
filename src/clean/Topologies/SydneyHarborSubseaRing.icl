implementation module Etalon.Topologies.SydneyHarborSubseaRing

/*
 * SydneyHarborSubseaRing.icl: Sydney Harbor Subsea optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.SydneyHarborSubseaRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

sydneyHarborSubseaRingNodeCount :== 12
sydneyHarborSubseaRingLinkCount :== 22

buildSydneyHarborSubseaRing :: *OpticalGraph
buildSydneyHarborSubseaRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > sydneyHarborSubseaRingNodeCount = g
        = let node = createCdcRoadmNode idx ("SydneyHarborSubseaRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 16.0, [5901]),
                (2, 2, 3, 16.0, [5902]),
                (3, 3, 4, 16.0, [5903]),
                (4, 4, 5, 16.0, [5904]),
                (5, 5, 6, 16.0, [5905]),
                (6, 6, 7, 16.0, [5906]),
                (7, 7, 8, 16.0, [5907]),
                (8, 8, 9, 16.0, [5908]),
                (9, 9, 10, 16.0, [5909]),
                (10, 10, 11, 16.0, [5910]),
                (11, 11, 12, 16.0, [5911]),
                (12, 12, 1, 16.0, [5912]),
                (13, 3, 6, 30.0, [5951]),
                (14, 5, 11, 30.0, [5952]),
                (15, 7, 4, 30.0, [5953]),
                (16, 9, 9, 30.0, [5954]),
                (17, 11, 2, 30.0, [5955]),
                (18, 1, 7, 30.0, [5956]),
                (19, 3, 12, 30.0, [5957]),
                (20, 5, 5, 30.0, [5958]),
                (21, 7, 10, 30.0, [5959]),
                (22, 9, 3, 30.0, [5960])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

implementation module Etalon.Topologies.EuroCore100

/*
 * EuroCore100.icl: 100-node European core implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.EuroCore100
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

euroCore100NodeCount :== 100
euroCore100LinkCount :== 240

buildEuroCore100 :: *OpticalGraph
buildEuroCore100 =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > euroCore100NodeCount = g
        = let node = createCdcRoadmNode idx ("EU100-" +++ toString idx) 8 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let ringLinks = [(i, ((i - 1) rem 100) + 1, (i rem 100) + 1, 280.0, [1000 + i]) \ i <- [1..100]]
            chordLinks = [(100 + i, ((i * 7) rem 100) + 1, ((i * 13) rem 100) + 1, 520.0, [1200 + i]) \ i <- [1..140]]
        in insertLinkList g (ringLinks ++ chordLinks)

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

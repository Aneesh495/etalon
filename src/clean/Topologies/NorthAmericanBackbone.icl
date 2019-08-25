implementation module Etalon.Topologies.NorthAmericanBackbone

/*
 * NorthAmericanBackbone.icl: 50-node carrier backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.NorthAmericanBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

naBackboneNodeCount :== 50
naBackboneLinkCount :== 112

buildNaBackbone :: *OpticalGraph
buildNaBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > naBackboneNodeCount = g
        = let node = createCdcRoadmNode idx ("NA-Node-" +++ toString idx) 6 48
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (i, ((i - 1) rem 50) + 1, (i rem 50) + 1, 350.0, [800 + i]) \ i <- [1..50]
            ] ++ [
                (50 + i, ((i * 3) rem 50) + 1, ((i * 7) rem 50) + 1, 650.0, [900 + i]) \ i <- [1..62]
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

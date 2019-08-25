implementation module Etalon.Topologies.GlobalSubseaMesh

/*
 * GlobalSubseaMesh.icl: Global subsea mesh implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.GlobalSubseaMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

globalLandingStationCount :== 30
globalSubseaSegmentCount  :== 48

buildGlobalSubseaMesh :: *OpticalGraph
buildGlobalSubseaMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > globalLandingStationCount = g
        = let node = createCdcRoadmNode idx ("Landing-" +++ toString idx) 4 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (i, ((i - 1) rem 30) + 1, (i rem 30) + 1, 4200.0, [2000 + i]) \ i <- [1..30]
            ] ++ [
                (30 + i, ((i * 5) rem 30) + 1, ((i * 11) rem 30) + 1, 7800.0, [2100 + i]) \ i <- [1..18]
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

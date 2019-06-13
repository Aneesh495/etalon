implementation module Etalon.Topologies.MetroRing

/*
 * MetroRing.icl: Implementation of the 8-node Metro optical aggregation ring.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.MetroRing

metroRingNodeCount :== 8
metroRingLinkCount :== 8

getMetroNodeName :: !Int -> String
getMetroNodeName 1 = "Downtown Core DC"
getMetroNodeName 2 = "Financial IXP"
getMetroNodeName 3 = "North Telco CO"
getMetroNodeName 4 = "Tech Hub Suburb DC"
getMetroNodeName 5 = "East Carrier Meet-Me"
getMetroNodeName 6 = "South Edge Gateway"
getMetroNodeName 7 = "Harbor Subsea Landing"
getMetroNodeName 8 = "West Cloud Region"
getMetroNodeName _ = "Unknown"

buildMetroRingTopology :: -> *OpticalGraph
buildMetroRingTopology =
    let g0 = createEmptyGraph
        g1 = addRingNodes g0 1
        g2 = addRingLinks g1
    in g2
where
    addRingNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addRingNodes g idx
        | idx > metroRingNodeCount = g
        = let name = getMetroNodeName idx
              node = createCdcRoadmNode idx name 2 64 // 2-degree ring nodes with dense add/drop
              nextG = addNodeToGraph g node
          in addRingNodes nextG (idx + 1)

    addRingLinks :: !*OpticalGraph -> *OpticalGraph
    addRingLinks g =
        let links = [
                (1, 1, 2, 12.0, [401]),
                (2, 2, 3, 18.0, [402]),
                (3, 3, 4, 25.0, [403]),
                (4, 4, 5, 22.0, [404]),
                (5, 5, 6, 15.0, [405]),
                (6, 6, 7, 28.0, [406]),
                (7, 7, 8, 32.0, [407]),
                (8, 8, 1, 14.0, [408])
            ]
        in foldl insertLinkPair g links

    insertLinkPair :: !*OpticalGraph !(Int, Int, Int, Real, [Int]) -> *OpticalGraph
    insertLinkPair curG (idNum, u, v, distKm, srlgs) =
        let spansFwd = [createSmf28Span 1 distKm 0.0]
            spansRev = [createSmf28Span 1 distKm 0.0]
            loss = distKm * 0.22
            lFwd = {
                linkId          = idNum * 2 - 1,
                sourceNodeId    = u,
                targetNodeId    = v,
                spans           = spansFwd,
                srlgList        = srlgs,
                operational     = True,
                totalDistanceKm = distKm,
                totalLossDb     = loss
            }
            lRev = {
                linkId          = idNum * 2,
                sourceNodeId    = v,
                targetNodeId    = u,
                spans           = spansRev,
                srlgList        = srlgs,
                operational     = True,
                totalDistanceKm = distKm,
                totalLossDb     = loss
            }
            g1 = addLinkToGraph curG lFwd
        in addLinkToGraph g1 lRev

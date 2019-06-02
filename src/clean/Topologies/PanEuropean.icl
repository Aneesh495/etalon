implementation module Etalon.Topologies.PanEuropean

/*
 * PanEuropean.icl: Implementation of the Pan-European optical backbone.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.PanEuropean

panEuropeanNodeCount :== 28
panEuropeanLinkCount :== 41

getPanEuroNodeName :: !Int -> String
getPanEuroNodeName 1  = "London"
getPanEuroNodeName 2  = "Paris"
getPanEuroNodeName 3  = "Frankfurt"
getPanEuroNodeName 4  = "Amsterdam"
getPanEuroNodeName 5  = "Brussels"
getPanEuroNodeName 6  = "Geneva"
getPanEuroNodeName 7  = "Zurich"
getPanEuroNodeName 8  = "Milan"
getPanEuroNodeName 9  = "Rome"
getPanEuroNodeName 10 = "Madrid"
getPanEuroNodeName 11 = "Barcelona"
getPanEuroNodeName 12 = "Lisbon"
getPanEuroNodeName 13 = "Dublin"
getPanEuroNodeName 14 = "Copenhagen"
getPanEuroNodeName 15 = "Stockholm"
getPanEuroNodeName 16 = "Oslo"
getPanEuroNodeName 17 = "Helsinki"
getPanEuroNodeName 18 = "Warsaw"
getPanEuroNodeName 19 = "Berlin"
getPanEuroNodeName 20 = "Prague"
getPanEuroNodeName 21 = "Vienna"
getPanEuroNodeName 22 = "Budapest"
getPanEuroNodeName 23 = "Zagreb"
getPanEuroNodeName 24 = "Belgrade"
getPanEuroNodeName 25 = "Bucharest"
getPanEuroNodeName 26 = "Sofia"
getPanEuroNodeName 27 = "Athens"
getPanEuroNodeName 28 = "Istanbul"
getPanEuroNodeName _  = "Unknown"

buildPanEuropeanTopology :: -> *OpticalGraph
buildPanEuropeanTopology =
    let g0 = createEmptyGraph
        g1 = addEuroNodes g0 1
        g2 = addEuroLinks g1
    in g2
where
    addEuroNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addEuroNodes g idx
        | idx > panEuropeanNodeCount = g
        = let name = getPanEuroNodeName idx
              node = createCdcRoadmNode idx name 4 32
              nextG = addNodeToGraph g node
          in addEuroNodes nextG (idx + 1)

    addEuroLinks :: !*OpticalGraph -> *OpticalGraph
    addEuroLinks g =
        let links = [
                (1, 1, 2, 340.0, [201]),   // London - Paris
                (2, 1, 4, 360.0, [202]),   // London - Amsterdam
                (3, 1, 13, 460.0, [203]),  // London - Dublin
                (4, 2, 5, 300.0, [204]),   // Paris - Brussels
                (5, 2, 6, 540.0, [205]),   // Paris - Geneva
                (6, 2, 10, 1050.0, [206]), // Paris - Madrid
                (7, 3, 4, 360.0, [207]),   // Frankfurt - Amsterdam
                (8, 3, 5, 320.0, [208]),   // Frankfurt - Brussels
                (9, 3, 7, 300.0, [209]),   // Frankfurt - Zurich
                (10, 3, 19, 550.0, [210]), // Frankfurt - Berlin
                (11, 3, 20, 510.0, [211]), // Frankfurt - Prague
                (12, 4, 5, 210.0, [212]),  // Amsterdam - Brussels
                (13, 4, 14, 620.0, [213]), // Amsterdam - Copenhagen
                (14, 6, 7, 280.0, [214]),  // Geneva - Zurich
                (15, 6, 8, 320.0, [215]),  // Geneva - Milan
                (16, 7, 8, 220.0, [216]),  // Zurich - Milan
                (17, 7, 21, 600.0, [217]), // Zurich - Vienna
                (18, 8, 9, 580.0, [218]),  // Milan - Rome
                (19, 8, 23, 570.0, [219]), // Milan - Zagreb
                (20, 9, 27, 1050.0, [220]),// Rome - Athens
                (21, 10, 11, 620.0, [221]),// Madrid - Barcelona
                (22, 10, 12, 500.0, [222]),// Madrid - Lisbon
                (23, 11, 2, 830.0, [223]), // Barcelona - Paris
                (24, 14, 15, 520.0, [224]),// Copenhagen - Stockholm
                (25, 14, 16, 480.0, [225]),// Copenhagen - Oslo
                (26, 15, 16, 420.0, [226]),// Stockholm - Oslo
                (27, 15, 17, 400.0, [227]),// Stockholm - Helsinki
                (28, 17, 18, 900.0, [228]),// Helsinki - Warsaw
                (29, 18, 19, 520.0, [229]),// Warsaw - Berlin
                (30, 18, 20, 540.0, [230]),// Warsaw - Prague
                (31, 19, 20, 280.0, [231]),// Berlin - Prague
                (32, 20, 21, 250.0, [232]),// Prague - Vienna
                (33, 21, 22, 220.0, [233]),// Vienna - Budapest
                (34, 21, 23, 370.0, [234]),// Vienna - Zagreb
                (35, 22, 24, 320.0, [235]),// Budapest - Belgrade
                (36, 22, 25, 640.0, [236]),// Budapest - Bucharest
                (37, 23, 24, 370.0, [237]),// Zagreb - Belgrade
                (38, 24, 26, 330.0, [238]),// Belgrade - Sofia
                (39, 25, 26, 300.0, [239]),// Bucharest - Sofia
                (40, 25, 28, 640.0, [240]),// Bucharest - Istanbul
                (41, 26, 27, 520.0, [241]) // Sofia - Athens
            ]
        in foldl insertLinkPair g links

    insertLinkPair :: !*OpticalGraph !(Int, Int, Int, Real, [Int]) -> *OpticalGraph
    insertLinkPair curG (idNum, u, v, distKm, srlgs) =
        let spansFwd = createSpans distKm
            spansRev = createSpans distKm
            loss = distKm * 0.20
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

    createSpans :: !Real -> [FiberSpan]
    createSpans totalKm =
        let numSpans = max 1 (toInt (ceil (totalKm / 80.0)))
            spanLen = totalKm / (toReal numSpans)
        in [createSmf28Span idx spanLen 0.0 \ idx <- [1..numSpans]]

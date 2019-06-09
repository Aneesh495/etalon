implementation module Etalon.Topologies.JapanBackbone

/*
 * JapanBackbone.icl: Implementation of the 14-node Japan optical backbone.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.JapanBackbone

japanNodeCount :== 14
japanLinkCount :== 21

getJapanNodeName :: !Int -> String
getJapanNodeName 1  = "Sapporo"
getJapanNodeName 2  = "Sendai"
getJapanNodeName 3  = "Niigata"
getJapanNodeName 4  = "Tokyo East"
getJapanNodeName 5  = "Tokyo West"
getJapanNodeName 6  = "Yokohama"
getJapanNodeName 7  = "Nagoya"
getJapanNodeName 8  = "Kanazawa"
getJapanNodeName 9  = "Kyoto"
getJapanNodeName 10 = "Osaka"
getJapanNodeName 11 = "Kobe"
getJapanNodeName 12 = "Hiroshima"
getJapanNodeName 13 = "Fukuoka"
getJapanNodeName 14 = "Kumamoto"
getJapanNodeName _  = "Unknown"

buildJapanTopology :: -> *OpticalGraph
buildJapanTopology =
    let g0 = createEmptyGraph
        g1 = addJpnNodes g0 1
        g2 = addJpnLinks g1
    in g2
where
    addJpnNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addJpnNodes g idx
        | idx > japanNodeCount = g
        = let name = getJapanNodeName idx
              node = createCdcRoadmNode idx name 4 24
              nextG = addNodeToGraph g node
          in addJpnNodes nextG (idx + 1)

    addJpnLinks :: !*OpticalGraph -> *OpticalGraph
    addJpnLinks g =
        let links = [
                (1, 1, 2, 540.0, [301]),   // Sapporo - Sendai (Tsugaru Strait cable)
                (2, 2, 3, 220.0, [302]),   // Sendai - Niigata
                (3, 2, 4, 350.0, [303]),   // Sendai - Tokyo East
                (4, 3, 8, 250.0, [304]),   // Niigata - Kanazawa
                (5, 4, 5, 30.0, [305]),    // Tokyo East - Tokyo West
                (6, 4, 6, 40.0, [306]),    // Tokyo East - Yokohama
                (7, 5, 7, 340.0, [307]),   // Tokyo West - Nagoya
                (8, 6, 7, 320.0, [308]),   // Yokohama - Nagoya
                (9, 7, 8, 210.0, [309]),   // Nagoya - Kanazawa
                (10, 7, 9, 140.0, [310]),  // Nagoya - Kyoto
                (11, 8, 9, 210.0, [311]),  // Kanazawa - Kyoto
                (12, 9, 10, 50.0, [312]),  // Kyoto - Osaka
                (13, 10, 11, 35.0, [313]), // Osaka - Kobe
                (14, 10, 7, 180.0, [314]), // Osaka - Nagoya
                (15, 11, 12, 300.0, [315]),// Kobe - Hiroshima
                (16, 12, 13, 280.0, [316]),// Hiroshima - Fukuoka
                (17, 13, 14, 110.0, [317]),// Fukuoka - Kumamoto
                (18, 14, 10, 580.0, [318]),// Kumamoto - Osaka (South bypass)
                (19, 5, 3, 260.0, [319]),  // Tokyo West - Niigata
                (20, 12, 10, 330.0, [320]),// Hiroshima - Osaka
                (21, 13, 11, 560.0, [321]) // Fukuoka - Kobe
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

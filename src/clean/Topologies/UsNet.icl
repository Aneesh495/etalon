implementation module Etalon.Topologies.UsNet

/*
 * UsNet.icl: Implementation of the 24-node US reference carrier network.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.UsNet

usNetNodeCount :== 24
usNetLinkCount :== 43

getUsNetNodeName :: !Int -> String
getUsNetNodeName 1  = "Seattle"
getUsNetNodeName 2  = "San Francisco"
getUsNetNodeName 3  = "Los Angeles"
getUsNetNodeName 4  = "San Diego"
getUsNetNodeName 5  = "Salt Lake City"
getUsNetNodeName 6  = "Phoenix"
getUsNetNodeName 7  = "Denver"
getUsNetNodeName 8  = "Dallas"
getUsNetNodeName 9  = "Houston"
getUsNetNodeName 10 = "Minneapolis"
getUsNetNodeName 11 = "Kansas City"
getUsNetNodeName 12 = "St Louis"
getUsNetNodeName 13 = "Chicago"
getUsNetNodeName 14 = "Indianapolis"
getUsNetNodeName 15 = "Detroit"
getUsNetNodeName 16 = "Cleveland"
getUsNetNodeName 17 = "Nashville"
getUsNetNodeName 18 = "Atlanta"
getUsNetNodeName 19 = "Miami"
getUsNetNodeName 20 = "Washington DC"
getUsNetNodeName 21 = "Philadelphia"
getUsNetNodeName 22 = "New York"
getUsNetNodeName 23 = "Boston"
getUsNetNodeName 24 = "Pittsburgh"
getUsNetNodeName _  = "Unknown"

getUsNetNodeCoords :: !Int -> (Real, Real)
getUsNetNodeCoords 1  = (47.6062, ~122.3321) // Seattle
getUsNetNodeCoords 2  = (37.7749, ~122.4194) // San Francisco
getUsNetNodeCoords 3  = (34.0522, ~118.2437) // Los Angeles
getUsNetNodeCoords 4  = (32.7157, ~117.1611) // San Diego
getUsNetNodeCoords 5  = (40.7608, ~111.8910) // Salt Lake City
getUsNetNodeCoords 6  = (33.4484, ~112.0740) // Phoenix
getUsNetNodeCoords 7  = (39.7392, ~104.9903) // Denver
getUsNetNodeCoords 8  = (32.7767, ~96.7970)  // Dallas
getUsNetNodeCoords 9  = (29.7604, ~95.3698)  // Houston
getUsNetNodeCoords 10 = (44.9778, ~93.2650)  // Minneapolis
getUsNetNodeCoords 11 = (39.0997, ~94.5786)  // Kansas City
getUsNetNodeCoords 12 = (38.6270, ~90.1994)  // St Louis
getUsNetNodeCoords 13 = (41.8781, ~87.6298)  // Chicago
getUsNetNodeCoords 14 = (39.7684, ~86.1581)  // Indianapolis
getUsNetNodeCoords 15 = (42.3314, ~83.0458)  // Detroit
getUsNetNodeCoords 16 = (41.4993, ~81.6944)  // Cleveland
getUsNetNodeCoords 17 = (36.1627, ~86.7816)  // Nashville
getUsNetNodeCoords 18 = (33.7490, ~84.3880)  // Atlanta
getUsNetNodeCoords 19 = (25.7617, ~80.1918)  // Miami
getUsNetNodeCoords 20 = (38.9072, ~77.0369)  // Washington DC
getUsNetNodeCoords 21 = (39.9526, ~75.1652)  // Philadelphia
getUsNetNodeCoords 22 = (40.7128, ~74.0060)  // New York
getUsNetNodeCoords 23 = (42.3601, ~71.0589)  // Boston
getUsNetNodeCoords 24 = (40.4406, ~79.9959)  // Pittsburgh
getUsNetNodeCoords _  = (0.0, 0.0)

buildUsNetTopology :: -> *OpticalGraph
buildUsNetTopology =
    let g0 = createEmptyGraph
        // Add 24 ROADM nodes
        g1 = addNodes g0 1
        // Add 43 fiber links
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > usNetNodeCount = g
        = let name = getUsNetNodeName idx
              node = createCdcRoadmNode idx name 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let linkDefs = [
                (1, 1, 2, 1300.0, [101]),   // Seattle - San Francisco
                (2, 1, 5, 1150.0, [102]),   // Seattle - Salt Lake City
                (3, 1, 10, 2250.0, [103]),  // Seattle - Minneapolis
                (4, 2, 3, 600.0, [104]),    // San Francisco - Los Angeles
                (5, 2, 5, 950.0, [105]),    // San Francisco - Salt Lake City
                (6, 3, 4, 190.0, [106]),    // Los Angeles - San Diego
                (7, 3, 6, 600.0, [107]),    // Los Angeles - Phoenix
                (8, 4, 6, 500.0, [108]),    // San Diego - Phoenix
                (9, 5, 7, 650.0, [109]),    // Salt Lake City - Denver
                (10, 6, 8, 1400.0, [110]),  // Phoenix - Dallas
                (11, 7, 11, 850.0, [111]),  // Denver - Kansas City
                (12, 7, 10, 1100.0, [112]), // Denver - Minneapolis
                (13, 8, 9, 390.0, [113]),   // Dallas - Houston
                (14, 8, 11, 750.0, [114]),  // Dallas - Kansas City
                (15, 8, 18, 1150.0, [115]), // Dallas - Atlanta
                (16, 9, 18, 1100.0, [116]), // Houston - Atlanta
                (17, 9, 19, 1550.0, [117]), // Houston - Miami
                (18, 10, 13, 580.0, [118]), // Minneapolis - Chicago
                (19, 11, 12, 400.0, [119]), // Kansas City - St Louis
                (20, 12, 13, 430.0, [120]), // St Louis - Chicago
                (21, 12, 14, 380.0, [121]), // St Louis - Indianapolis
                (22, 12, 17, 450.0, [122]), // St Louis - Nashville
                (23, 13, 14, 290.0, [123]), // Chicago - Indianapolis
                (24, 13, 15, 450.0, [124]), // Chicago - Detroit
                (25, 14, 16, 450.0, [125]), // Indianapolis - Cleveland
                (26, 14, 17, 460.0, [126]), // Indianapolis - Nashville
                (27, 15, 16, 270.0, [127]), // Detroit - Cleveland
                (28, 16, 24, 210.0, [128]), // Cleveland - Pittsburgh
                (29, 16, 22, 650.0, [129]), // Cleveland - New York
                (30, 17, 18, 350.0, [130]), // Nashville - Atlanta
                (31, 18, 19, 970.0, [131]), // Atlanta - Miami
                (32, 18, 20, 850.0, [132]), // Atlanta - Washington DC
                (33, 19, 20, 1500.0, [133]),// Miami - Washington DC
                (34, 20, 21, 200.0, [134]), // Washington DC - Philadelphia
                (35, 20, 24, 350.0, [135]), // Washington DC - Pittsburgh
                (36, 21, 22, 150.0, [136]), // Philadelphia - New York
                (37, 22, 23, 340.0, [137]), // New York - Boston
                (38, 22, 24, 500.0, [138]), // New York - Pittsburgh
                (39, 23, 15, 980.0, [139]), // Boston - Detroit
                (40, 24, 13, 700.0, [140]), // Pittsburgh - Chicago
                (41, 5, 8, 1600.0, [141]),  // Salt Lake City - Dallas
                (42, 6, 7, 850.0, [142]),   // Phoenix - Denver
                (43, 10, 15, 850.0, [143])  // Minneapolis - Detroit
            ]
        in foldl insertLinkPair g linkDefs

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

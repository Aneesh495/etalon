#!/usr/bin/env python3
"""
Generator for Etalon Clean Topologies subsystem:
  - UsNet (24 nodes, 43 links)
  - PanEuropean (28 nodes, 41 links)
  - TransatlanticSubsea (6600 km, 110 repeaters)
  - JapanBackbone (14 nodes, 21 links)
  - MetroRing (8 nodes, 16 links)

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
TOPOLOGY_DIR = REPO_ROOT / "src" / "clean" / "Topologies"
TOPOLOGY_DIR.mkdir(parents=True, exist_ok=True)

def write_file(path: Path, content: str):
    assert "\u2014" not in content, f"Em dash violation in {path}"
    path.write_text(content, encoding="utf-8")
    print(f"Wrote {path.relative_to(REPO_ROOT)}")

def build_usnet():
    dcl = """definition module Etalon.Topologies.UsNet

/*
 * UsNet.dcl: 24-node US-wide reference carrier optical mesh network.
 *
 * Models a transcontinental backbone spanning major metropolitan areas:
 * Seattle, San Francisco, Los Angeles, San Diego, Salt Lake City, Phoenix,
 * Denver, Dallas, Houston, Minneapolis, Kansas City, St Louis, Chicago,
 * Indianapolis, Detroit, Cleveland, Nashville, Atlanta, Miami, Washington DC,
 * Philadelphia, New York, Boston, and Pittsburgh.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

usNetNodeCount :: !Int
usNetLinkCount :: !Int

buildUsNetTopology :: -> *OpticalGraph
getUsNetNodeName   :: !Int -> String
getUsNetNodeCoords :: !Int -> (Real, Real) // Latitude, Longitude
"""

    # Generate 24 nodes and 43 bidirectional links with real distances and coordinates
    icl = """implementation module Etalon.Topologies.UsNet

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
        in [createSmf28Span idx spanLen 0.0 \\ idx <- [1..numSpans]]
"""
    write_file(TOPOLOGY_DIR / "UsNet.dcl", dcl)
    write_file(TOPOLOGY_DIR / "UsNet.icl", icl)

def build_pan_european():
    dcl = """definition module Etalon.Topologies.PanEuropean

/*
 * PanEuropean.dcl: 28-node Pan-European core optical backbone network.
 *
 * Models a trans-European mesh spanning London, Paris, Frankfurt, Amsterdam,
 * Brussels, Geneva, Zurich, Milan, Rome, Madrid, Barcelona, Lisbon, Dublin,
 * Copenhagen, Stockholm, Oslo, Helsinki, Warsaw, Berlin, Prague, Vienna,
 * Budapest, Zagreb, Belgrade, Bucharest, Sofia, Athens, and Istanbul.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

panEuropeanNodeCount :: !Int
panEuropeanLinkCount :: !Int

buildPanEuropeanTopology :: -> *OpticalGraph
getPanEuroNodeName       :: !Int -> String
"""
    icl = """implementation module Etalon.Topologies.PanEuropean

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
        in [createSmf28Span idx spanLen 0.0 \\ idx <- [1..numSpans]]
"""
    write_file(TOPOLOGY_DIR / "PanEuropean.dcl", dcl)
    write_file(TOPOLOGY_DIR / "PanEuropean.icl", icl)

def build_transatlantic_subsea():
    dcl = """definition module Etalon.Topologies.TransatlanticSubsea

/*
 * TransatlanticSubsea.dcl: 6,600 km Transoceanic Submarine Cable System.
 *
 * Models an ultra-long-haul transoceanic optical cable (e.g. Dunant / Marea / TAT-14)
 * connecting North America (Virginia Beach) and Europe (Saint-Hilaire-de-Riez / Bilbao).
 * Features:
 *   - Pure silica core fiber (PSCF) with 0.15 dB/km ultra-low attenuation
 *   - 110 submerged optical repeaters spaced at 60 km intervals
 *   - Space-Division Multiplexing (SDM) with 12 to 24 fiber pairs
 *   - Positive dispersion uncompensated link with coherent DSP equalization
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

subseaCableLengthKm  :== 6600.0
subseaRepeaterCount  :== 110
subseaRepeaterSpacingKm :== 60.0

buildSubseaTopology  :: -> *OpticalGraph
getSubseaRepeaterGainDb :: -> Real
"""
    icl = """implementation module Etalon.Topologies.TransatlanticSubsea

/*
 * TransatlanticSubsea.icl: Implementation of the Transatlantic submarine cable model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.TransatlanticSubsea

getSubseaRepeaterGainDb :: -> Real
getSubseaRepeaterGainDb = subseaRepeaterSpacingKm * 0.15 // 60 km * 0.15 dB/km = 9.0 dB gain

buildSubseaTopology :: -> *OpticalGraph
buildSubseaTopology =
    let g0 = createEmptyGraph
        // Cable landing stations (CLS)
        clsWest = createCdcRoadmNode 1 "Virginia Beach CLS (USA)" 2 64
        clsEast = createCdcRoadmNode 2 "Saint-Hilaire CLS (France)" 2 64
        g1 = addNodeToGraph (addNodeToGraph g0 clsWest) clsEast
        // Build 110 fiber spans and repeaters
        spans = [createSubseaSpan idx \\ idx <- [1..subseaRepeaterCount]]
        totalDist = subseaCableLengthKm
        totalLoss = subseaRepeaterCount * (subseaRepeaterSpacingKm * 0.15)
        linkFwd = {
            linkId          = 1,
            sourceNodeId    = 1,
            targetNodeId    = 2,
            spans           = spans,
            srlgList        = [999], // Dedicated subsea corridor
            operational     = True,
            totalDistanceKm = totalDist,
            totalLossDb     = totalLoss
        }
        linkRev = {
            linkId          = 2,
            sourceNodeId    = 2,
            targetNodeId    = 1,
            spans           = spans,
            srlgList        = [999],
            operational     = True,
            totalDistanceKm = totalDist,
            totalLossDb     = totalLoss
        }
        g2 = addLinkToGraph (addLinkToGraph g1 linkFwd) linkRev
    in g2
where
    createSubseaSpan :: !Int -> FiberSpan
    createSubseaSpan sId =
        createCustomSpan sId PureSilica subseaRepeaterSpacingKm 0.15 21.0 0.060 0.03 112.0 2.2e-20 (~2.0)
"""
    write_file(TOPOLOGY_DIR / "TransatlanticSubsea.dcl", dcl)
    write_file(TOPOLOGY_DIR / "TransatlanticSubsea.icl", icl)

def build_japan_backbone():
    dcl = """definition module Etalon.Topologies.JapanBackbone

/*
 * JapanBackbone.dcl: 14-node Japanese national optical backbone network.
 *
 * Models a disaster-resilient ring-and-mesh topology spanning:
 * Sapporo, Sendai, Niigata, Tokyo East, Tokyo West, Yokohama, Nagoya,
 * Kanazawa, Kyoto, Osaka, Kobe, Hiroshima, Fukuoka, and Kumamoto.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

japanNodeCount :: !Int
japanLinkCount :: !Int

buildJapanTopology :: -> *OpticalGraph
getJapanNodeName   :: !Int -> String
"""
    icl = """implementation module Etalon.Topologies.JapanBackbone

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
        in [createSmf28Span idx spanLen 0.0 \\ idx <- [1..numSpans]]
"""
    write_file(TOPOLOGY_DIR / "JapanBackbone.dcl", dcl)
    write_file(TOPOLOGY_DIR / "JapanBackbone.icl", icl)

def build_metro_ring():
    dcl = """definition module Etalon.Topologies.MetroRing

/*
 * MetroRing.dcl: 8-node Resilient Metro DWDM Aggregation Ring.
 *
 * Models a dense metropolitan optical ring connecting data centers, central offices,
 * and internet exchange points (IXPs) with sub-10ms protection failover.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

metroRingNodeCount :: !Int
metroRingLinkCount :: !Int

buildMetroRingTopology :: -> *OpticalGraph
getMetroNodeName       :: !Int -> String
"""
    icl = """implementation module Etalon.Topologies.MetroRing

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
"""
    write_file(TOPOLOGY_DIR / "MetroRing.dcl", dcl)
    write_file(TOPOLOGY_DIR / "MetroRing.icl", icl)

def main():
    print("Generating Clean Topologies...")
    build_usnet()
    build_pan_european()
    build_transatlantic_subsea()
    build_japan_backbone()
    build_metro_ring()
    print("Done generating Clean Topologies.")

if __name__ == "__main__":
    main()

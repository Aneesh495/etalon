implementation module Etalon.Topologies.AustraliaBackbone

/*
 * AustraliaBackbone.icl: Australia optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.AustraliaBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

australiaBackboneNodeCount :== 18
australiaBackboneLinkCount :== 25

buildAustraliaBackbone :: *OpticalGraph
buildAustraliaBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > australiaBackboneNodeCount = g
        = let node = createCdcRoadmNode idx ("AustraliaBackbone-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 950.0, [3401]),
                (2, 2, 3, 950.0, [3402]),
                (3, 3, 4, 950.0, [3403]),
                (4, 4, 5, 950.0, [3404]),
                (5, 5, 6, 950.0, [3405]),
                (6, 6, 7, 950.0, [3406]),
                (7, 7, 8, 950.0, [3407]),
                (8, 8, 9, 950.0, [3408]),
                (9, 9, 10, 950.0, [3409]),
                (10, 10, 11, 950.0, [3410]),
                (11, 11, 12, 950.0, [3411]),
                (12, 12, 13, 950.0, [3412]),
                (13, 13, 14, 950.0, [3413]),
                (14, 14, 15, 950.0, [3414]),
                (15, 15, 16, 950.0, [3415]),
                (16, 16, 17, 950.0, [3416]),
                (17, 17, 18, 950.0, [3417]),
                (18, 18, 1, 950.0, [3418]),
                (19, 3, 6, 1600.0, [3451]),
                (20, 5, 11, 1600.0, [3452]),
                (21, 7, 16, 1600.0, [3453]),
                (22, 9, 3, 1600.0, [3454]),
                (23, 11, 8, 1600.0, [3455]),
                (24, 13, 13, 1600.0, [3456]),
                (25, 15, 18, 1600.0, [3457])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

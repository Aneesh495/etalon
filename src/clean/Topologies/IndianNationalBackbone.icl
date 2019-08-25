implementation module Etalon.Topologies.IndianNationalBackbone

/*
 * IndianNationalBackbone.icl: India optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.IndianNationalBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

indianNationalBackboneNodeCount :== 40
indianNationalBackboneLinkCount :== 60

buildIndianNationalBackbone :: *OpticalGraph
buildIndianNationalBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > indianNationalBackboneNodeCount = g
        = let node = createCdcRoadmNode idx ("IndianNationalBackbone-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 320.0, [3001]),
                (2, 2, 3, 320.0, [3002]),
                (3, 3, 4, 320.0, [3003]),
                (4, 4, 5, 320.0, [3004]),
                (5, 5, 6, 320.0, [3005]),
                (6, 6, 7, 320.0, [3006]),
                (7, 7, 8, 320.0, [3007]),
                (8, 8, 9, 320.0, [3008]),
                (9, 9, 10, 320.0, [3009]),
                (10, 10, 11, 320.0, [3010]),
                (11, 11, 12, 320.0, [3011]),
                (12, 12, 13, 320.0, [3012]),
                (13, 13, 14, 320.0, [3013]),
                (14, 14, 15, 320.0, [3014]),
                (15, 15, 16, 320.0, [3015]),
                (16, 16, 17, 320.0, [3016]),
                (17, 17, 18, 320.0, [3017]),
                (18, 18, 19, 320.0, [3018]),
                (19, 19, 20, 320.0, [3019]),
                (20, 20, 21, 320.0, [3020]),
                (21, 21, 22, 320.0, [3021]),
                (22, 22, 23, 320.0, [3022]),
                (23, 23, 24, 320.0, [3023]),
                (24, 24, 25, 320.0, [3024]),
                (25, 25, 26, 320.0, [3025]),
                (26, 26, 27, 320.0, [3026]),
                (27, 27, 28, 320.0, [3027]),
                (28, 28, 29, 320.0, [3028]),
                (29, 29, 30, 320.0, [3029]),
                (30, 30, 31, 320.0, [3030]),
                (31, 31, 32, 320.0, [3031]),
                (32, 32, 33, 320.0, [3032]),
                (33, 33, 34, 320.0, [3033]),
                (34, 34, 35, 320.0, [3034]),
                (35, 35, 36, 320.0, [3035]),
                (36, 36, 37, 320.0, [3036]),
                (37, 37, 38, 320.0, [3037]),
                (38, 38, 39, 320.0, [3038]),
                (39, 39, 40, 320.0, [3039]),
                (40, 40, 1, 320.0, [3040]),
                (41, 4, 8, 550.0, [3051]),
                (42, 7, 15, 550.0, [3052]),
                (43, 10, 22, 550.0, [3053]),
                (44, 13, 29, 550.0, [3054]),
                (45, 16, 36, 550.0, [3055]),
                (46, 19, 3, 550.0, [3056]),
                (47, 22, 10, 550.0, [3057]),
                (48, 25, 17, 550.0, [3058]),
                (49, 28, 24, 550.0, [3059]),
                (50, 31, 31, 550.0, [3060]),
                (51, 34, 38, 550.0, [3061]),
                (52, 37, 5, 550.0, [3062]),
                (53, 40, 12, 550.0, [3063]),
                (54, 3, 19, 550.0, [3064]),
                (55, 6, 26, 550.0, [3065]),
                (56, 9, 33, 550.0, [3066]),
                (57, 12, 40, 550.0, [3067]),
                (58, 15, 7, 550.0, [3068]),
                (59, 18, 14, 550.0, [3069]),
                (60, 21, 21, 550.0, [3070])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

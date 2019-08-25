implementation module Etalon.Topologies.LatinAmericaSubsea

/*
 * LatinAmericaSubsea.icl: Latin America optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.LatinAmericaSubsea
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

latinAmericaSubseaNodeCount :== 25
latinAmericaSubseaLinkCount :== 35

buildLatinAmericaSubsea :: *OpticalGraph
buildLatinAmericaSubsea =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > latinAmericaSubseaNodeCount = g
        = let node = createCdcRoadmNode idx ("LatinAmericaSubsea-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 850.0, [3301]),
                (2, 2, 3, 850.0, [3302]),
                (3, 3, 4, 850.0, [3303]),
                (4, 4, 5, 850.0, [3304]),
                (5, 5, 6, 850.0, [3305]),
                (6, 6, 7, 850.0, [3306]),
                (7, 7, 8, 850.0, [3307]),
                (8, 8, 9, 850.0, [3308]),
                (9, 9, 10, 850.0, [3309]),
                (10, 10, 11, 850.0, [3310]),
                (11, 11, 12, 850.0, [3311]),
                (12, 12, 13, 850.0, [3312]),
                (13, 13, 14, 850.0, [3313]),
                (14, 14, 15, 850.0, [3314]),
                (15, 15, 16, 850.0, [3315]),
                (16, 16, 17, 850.0, [3316]),
                (17, 17, 18, 850.0, [3317]),
                (18, 18, 19, 850.0, [3318]),
                (19, 19, 20, 850.0, [3319]),
                (20, 20, 21, 850.0, [3320]),
                (21, 21, 22, 850.0, [3321]),
                (22, 22, 23, 850.0, [3322]),
                (23, 23, 24, 850.0, [3323]),
                (24, 24, 25, 850.0, [3324]),
                (25, 25, 1, 850.0, [3325]),
                (26, 5, 10, 1400.0, [3351]),
                (27, 9, 19, 1400.0, [3352]),
                (28, 13, 3, 1400.0, [3353]),
                (29, 17, 12, 1400.0, [3354]),
                (30, 21, 21, 1400.0, [3355]),
                (31, 25, 5, 1400.0, [3356]),
                (32, 4, 14, 1400.0, [3357]),
                (33, 8, 23, 1400.0, [3358]),
                (34, 12, 7, 1400.0, [3359]),
                (35, 16, 16, 1400.0, [3360])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

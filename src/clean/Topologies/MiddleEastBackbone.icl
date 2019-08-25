implementation module Etalon.Topologies.MiddleEastBackbone

/*
 * MiddleEastBackbone.icl: Middle East optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.MiddleEastBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

middleEastBackboneNodeCount :== 16
middleEastBackboneLinkCount :== 24

buildMiddleEastBackbone :: *OpticalGraph
buildMiddleEastBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > middleEastBackboneNodeCount = g
        = let node = createCdcRoadmNode idx ("MiddleEastBackbone-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 380.0, [3701]),
                (2, 2, 3, 380.0, [3702]),
                (3, 3, 4, 380.0, [3703]),
                (4, 4, 5, 380.0, [3704]),
                (5, 5, 6, 380.0, [3705]),
                (6, 6, 7, 380.0, [3706]),
                (7, 7, 8, 380.0, [3707]),
                (8, 8, 9, 380.0, [3708]),
                (9, 9, 10, 380.0, [3709]),
                (10, 10, 11, 380.0, [3710]),
                (11, 11, 12, 380.0, [3711]),
                (12, 12, 13, 380.0, [3712]),
                (13, 13, 14, 380.0, [3713]),
                (14, 14, 15, 380.0, [3714]),
                (15, 15, 16, 380.0, [3715]),
                (16, 16, 1, 380.0, [3716]),
                (17, 4, 6, 750.0, [3751]),
                (18, 7, 11, 750.0, [3752]),
                (19, 10, 16, 750.0, [3753]),
                (20, 13, 5, 750.0, [3754]),
                (21, 16, 10, 750.0, [3755]),
                (22, 3, 15, 750.0, [3756]),
                (23, 6, 4, 750.0, [3757]),
                (24, 9, 9, 750.0, [3758])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

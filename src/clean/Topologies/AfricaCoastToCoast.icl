implementation module Etalon.Topologies.AfricaCoastToCoast

/*
 * AfricaCoastToCoast.icl: Africa optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.AfricaCoastToCoast
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

africaCoastToCoastNodeCount :== 35
africaCoastToCoastLinkCount :== 50

buildAfricaCoastToCoast :: *OpticalGraph
buildAfricaCoastToCoast =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > africaCoastToCoastNodeCount = g
        = let node = createCdcRoadmNode idx ("AfricaCoastToCoast-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 720.0, [3801]),
                (2, 2, 3, 720.0, [3802]),
                (3, 3, 4, 720.0, [3803]),
                (4, 4, 5, 720.0, [3804]),
                (5, 5, 6, 720.0, [3805]),
                (6, 6, 7, 720.0, [3806]),
                (7, 7, 8, 720.0, [3807]),
                (8, 8, 9, 720.0, [3808]),
                (9, 9, 10, 720.0, [3809]),
                (10, 10, 11, 720.0, [3810]),
                (11, 11, 12, 720.0, [3811]),
                (12, 12, 13, 720.0, [3812]),
                (13, 13, 14, 720.0, [3813]),
                (14, 14, 15, 720.0, [3814]),
                (15, 15, 16, 720.0, [3815]),
                (16, 16, 17, 720.0, [3816]),
                (17, 17, 18, 720.0, [3817]),
                (18, 18, 19, 720.0, [3818]),
                (19, 19, 20, 720.0, [3819]),
                (20, 20, 21, 720.0, [3820]),
                (21, 21, 22, 720.0, [3821]),
                (22, 22, 23, 720.0, [3822]),
                (23, 23, 24, 720.0, [3823]),
                (24, 24, 25, 720.0, [3824]),
                (25, 25, 26, 720.0, [3825]),
                (26, 26, 27, 720.0, [3826]),
                (27, 27, 28, 720.0, [3827]),
                (28, 28, 29, 720.0, [3828]),
                (29, 29, 30, 720.0, [3829]),
                (30, 30, 31, 720.0, [3830]),
                (31, 31, 32, 720.0, [3831]),
                (32, 32, 33, 720.0, [3832]),
                (33, 33, 34, 720.0, [3833]),
                (34, 34, 35, 720.0, [3834]),
                (35, 35, 1, 720.0, [3835]),
                (36, 5, 12, 1500.0, [3851]),
                (37, 9, 23, 1500.0, [3852]),
                (38, 13, 34, 1500.0, [3853]),
                (39, 17, 10, 1500.0, [3854]),
                (40, 21, 21, 1500.0, [3855]),
                (41, 25, 32, 1500.0, [3856]),
                (42, 29, 8, 1500.0, [3857]),
                (43, 33, 19, 1500.0, [3858]),
                (44, 2, 30, 1500.0, [3859]),
                (45, 6, 6, 1500.0, [3860]),
                (46, 10, 17, 1500.0, [3861]),
                (47, 14, 28, 1500.0, [3862]),
                (48, 18, 4, 1500.0, [3863]),
                (49, 22, 15, 1500.0, [3864]),
                (50, 26, 26, 1500.0, [3865])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

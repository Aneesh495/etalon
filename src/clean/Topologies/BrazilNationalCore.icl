implementation module Etalon.Topologies.BrazilNationalCore

/*
 * BrazilNationalCore.icl: Brazil optical backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.BrazilNationalCore
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

brazilNationalCoreNodeCount :== 26
brazilNationalCoreLinkCount :== 38

buildBrazilNationalCore :: *OpticalGraph
buildBrazilNationalCore =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > brazilNationalCoreNodeCount = g
        = let node = createCdcRoadmNode idx ("BrazilNationalCore-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 410.0, [4101]),
                (2, 2, 3, 410.0, [4102]),
                (3, 3, 4, 410.0, [4103]),
                (4, 4, 5, 410.0, [4104]),
                (5, 5, 6, 410.0, [4105]),
                (6, 6, 7, 410.0, [4106]),
                (7, 7, 8, 410.0, [4107]),
                (8, 8, 9, 410.0, [4108]),
                (9, 9, 10, 410.0, [4109]),
                (10, 10, 11, 410.0, [4110]),
                (11, 11, 12, 410.0, [4111]),
                (12, 12, 13, 410.0, [4112]),
                (13, 13, 14, 410.0, [4113]),
                (14, 14, 15, 410.0, [4114]),
                (15, 15, 16, 410.0, [4115]),
                (16, 16, 17, 410.0, [4116]),
                (17, 17, 18, 410.0, [4117]),
                (18, 18, 19, 410.0, [4118]),
                (19, 19, 20, 410.0, [4119]),
                (20, 20, 21, 410.0, [4120]),
                (21, 21, 22, 410.0, [4121]),
                (22, 22, 23, 410.0, [4122]),
                (23, 23, 24, 410.0, [4123]),
                (24, 24, 25, 410.0, [4124]),
                (25, 25, 26, 410.0, [4125]),
                (26, 26, 1, 410.0, [4126]),
                (27, 4, 9, 980.0, [4151]),
                (28, 7, 17, 980.0, [4152]),
                (29, 10, 25, 980.0, [4153]),
                (30, 13, 7, 980.0, [4154]),
                (31, 16, 15, 980.0, [4155]),
                (32, 19, 23, 980.0, [4156]),
                (33, 22, 5, 980.0, [4157]),
                (34, 25, 13, 980.0, [4158]),
                (35, 2, 21, 980.0, [4159]),
                (36, 5, 3, 980.0, [4160]),
                (37, 8, 11, 980.0, [4161]),
                (38, 11, 19, 980.0, [4162])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

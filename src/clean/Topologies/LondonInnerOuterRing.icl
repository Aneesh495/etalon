implementation module Etalon.Topologies.LondonInnerOuterRing

/*
 * LondonInnerOuterRing.icl: London Metro optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.LondonInnerOuterRing
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

londonInnerOuterRingNodeCount :== 18
londonInnerOuterRingLinkCount :== 36

buildLondonInnerOuterRing :: *OpticalGraph
buildLondonInnerOuterRing =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > londonInnerOuterRingNodeCount = g
        = let node = createCdcRoadmNode idx ("LondonInnerOuterRing-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 12.0, [5101]),
                (2, 2, 3, 12.0, [5102]),
                (3, 3, 4, 12.0, [5103]),
                (4, 4, 5, 12.0, [5104]),
                (5, 5, 6, 12.0, [5105]),
                (6, 6, 7, 12.0, [5106]),
                (7, 7, 8, 12.0, [5107]),
                (8, 8, 9, 12.0, [5108]),
                (9, 9, 10, 12.0, [5109]),
                (10, 10, 11, 12.0, [5110]),
                (11, 11, 12, 12.0, [5111]),
                (12, 12, 13, 12.0, [5112]),
                (13, 13, 14, 12.0, [5113]),
                (14, 14, 15, 12.0, [5114]),
                (15, 15, 16, 12.0, [5115]),
                (16, 16, 17, 12.0, [5116]),
                (17, 17, 18, 12.0, [5117]),
                (18, 18, 1, 12.0, [5118]),
                (19, 3, 8, 24.0, [5151]),
                (20, 5, 15, 24.0, [5152]),
                (21, 7, 4, 24.0, [5153]),
                (22, 9, 11, 24.0, [5154]),
                (23, 11, 18, 24.0, [5155]),
                (24, 13, 7, 24.0, [5156]),
                (25, 15, 14, 24.0, [5157]),
                (26, 17, 3, 24.0, [5158]),
                (27, 1, 10, 24.0, [5159]),
                (28, 3, 17, 24.0, [5160]),
                (29, 5, 6, 24.0, [5161]),
                (30, 7, 13, 24.0, [5162]),
                (31, 9, 2, 24.0, [5163]),
                (32, 11, 9, 24.0, [5164]),
                (33, 13, 16, 24.0, [5165]),
                (34, 15, 5, 24.0, [5166]),
                (35, 17, 12, 24.0, [5167]),
                (36, 1, 1, 24.0, [5168])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

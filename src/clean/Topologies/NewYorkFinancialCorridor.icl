implementation module Etalon.Topologies.NewYorkFinancialCorridor

/*
 * NewYorkFinancialCorridor.icl: New York / NJ Financial optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.NewYorkFinancialCorridor
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

newYorkFinancialCorridorNodeCount :== 20
newYorkFinancialCorridorLinkCount :== 40

buildNewYorkFinancialCorridor :: *OpticalGraph
buildNewYorkFinancialCorridor =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > newYorkFinancialCorridorNodeCount = g
        = let node = createCdcRoadmNode idx ("NewYorkFinancialCorridor-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 8.0, [5301]),
                (2, 2, 3, 8.0, [5302]),
                (3, 3, 4, 8.0, [5303]),
                (4, 4, 5, 8.0, [5304]),
                (5, 5, 6, 8.0, [5305]),
                (6, 6, 7, 8.0, [5306]),
                (7, 7, 8, 8.0, [5307]),
                (8, 8, 9, 8.0, [5308]),
                (9, 9, 10, 8.0, [5309]),
                (10, 10, 11, 8.0, [5310]),
                (11, 11, 12, 8.0, [5311]),
                (12, 12, 13, 8.0, [5312]),
                (13, 13, 14, 8.0, [5313]),
                (14, 14, 15, 8.0, [5314]),
                (15, 15, 16, 8.0, [5315]),
                (16, 16, 17, 8.0, [5316]),
                (17, 17, 18, 8.0, [5317]),
                (18, 18, 19, 8.0, [5318]),
                (19, 19, 20, 8.0, [5319]),
                (20, 20, 1, 8.0, [5320]),
                (21, 4, 8, 18.0, [5351]),
                (22, 7, 15, 18.0, [5352]),
                (23, 10, 2, 18.0, [5353]),
                (24, 13, 9, 18.0, [5354]),
                (25, 16, 16, 18.0, [5355]),
                (26, 19, 3, 18.0, [5356]),
                (27, 2, 10, 18.0, [5357]),
                (28, 5, 17, 18.0, [5358]),
                (29, 8, 4, 18.0, [5359]),
                (30, 11, 11, 18.0, [5360]),
                (31, 14, 18, 18.0, [5361]),
                (32, 17, 5, 18.0, [5362]),
                (33, 20, 12, 18.0, [5363]),
                (34, 3, 19, 18.0, [5364]),
                (35, 6, 6, 18.0, [5365]),
                (36, 9, 13, 18.0, [5366]),
                (37, 12, 20, 18.0, [5367]),
                (38, 15, 7, 18.0, [5368]),
                (39, 18, 14, 18.0, [5369]),
                (40, 1, 1, 18.0, [5370])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

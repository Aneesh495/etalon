implementation module Etalon.Topologies.Cost239

/*
 * Cost239.icl: COST-239 topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.Cost239
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

cost239NodeCount :== 11
cost239LinkCount :== 26

buildCost239 :: *OpticalGraph
buildCost239 =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > cost239NodeCount = g
        = let node = createCdcRoadmNode idx ("COST239-" +++ toString idx) 5 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 450.0, [601]),
                (2, 1, 3, 380.0, [602]),
                (3, 1, 4, 520.0, [603]),
                (4, 2, 3, 310.0, [604]),
                (5, 2, 5, 410.0, [605]),
                (6, 3, 4, 390.0, [606]),
                (7, 3, 6, 480.0, [607]),
                (8, 4, 5, 290.0, [608]),
                (9, 4, 7, 550.0, [609]),
                (10, 5, 6, 320.0, [610]),
                (11, 5, 8, 470.0, [611]),
                (12, 6, 7, 360.0, [612]),
                (13, 6, 9, 510.0, [613]),
                (14, 7, 8, 300.0, [614]),
                (15, 7, 10, 440.0, [615]),
                (16, 8, 9, 330.0, [616]),
                (17, 8, 11, 490.0, [617]),
                (18, 9, 10, 280.0, [618]),
                (19, 9, 11, 370.0, [619]),
                (20, 10, 11, 260.0, [620]),
                (21, 1, 6, 600.0, [621]),
                (22, 2, 7, 650.0, [622]),
                (23, 3, 8, 590.0, [623]),
                (24, 4, 9, 630.0, [624]),
                (25, 5, 10, 670.0, [625]),
                (26, 6, 11, 580.0, [626])
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest

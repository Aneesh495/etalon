implementation module Etalon.Topologies.AustralianAcademicAarnet

/*
 * AustralianAcademicAarnet.icl: Australian Academic AARNet optical network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.AustralianAcademicAarnet
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

australianAcademicAarnetNodeCount :== 10
australianAcademicAarnetLinkCount :== 18

buildAustralianAcademicAarnet :: *OpticalGraph
buildAustralianAcademicAarnet =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > 10 = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ (1, 1, 2, 750.0, [6701]),
                (2, 2, 3, 750.0, [6702]),
                (3, 3, 4, 750.0, [6703]),
                (4, 4, 5, 750.0, [6704]),
                (5, 5, 6, 750.0, [6705]),
                (6, 6, 7, 750.0, [6706]),
                (7, 7, 8, 750.0, [6707]),
                (8, 8, 9, 750.0, [6708]),
                (9, 9, 10, 750.0, [6709]),
                (10, 10, 1, 750.0, [6710]),
                (11, 3, 6, 1400.0, [6751]),
                (12, 5, 1, 1400.0, [6752]),
                (13, 7, 6, 1400.0, [6753]),
                (14, 9, 1, 1400.0, [6754]),
                (15, 1, 6, 1400.0, [6755]),
                (16, 3, 1, 1400.0, [6756]),
                (17, 5, 6, 1400.0, [6757]),
                (18, 7, 1, 1400.0, [6758])
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest

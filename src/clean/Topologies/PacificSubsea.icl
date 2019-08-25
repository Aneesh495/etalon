implementation module Etalon.Topologies.PacificSubsea

/*
 * PacificSubsea.icl: Trans-Pacific cable implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.PacificSubsea
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

pacificCableLengthKm :== 12000.0
pacificRepeaterCount :== 200

buildPacificSubseaCable :: *OpticalGraph
buildPacificSubseaCable =
    let g0 = createEmptyOpticalGraph
        // Nodes: 1 = Los Angeles, 2 = Hawaii BU, 3 = Guam BU, 4 = Tokyo
        n1 = createCdcRoadmNode 1 "LA-Landing" 2 64
        n2 = createCdcRoadmNode 2 "Hawaii-BU" 3 32
        n3 = createCdcRoadmNode 3 "Guam-BU" 3 32
        n4 = createCdcRoadmNode 4 "Tokyo-Landing" 2 64
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3) n4
        l1 = createOpticalLink 1 1 2 4000.0 []
        l2 = createOpticalLink 2 2 3 5500.0 []
        l3 = createOpticalLink 3 3 4 2500.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3
    in g2

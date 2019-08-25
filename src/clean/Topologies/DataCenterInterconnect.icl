implementation module Etalon.Topologies.DataCenterInterconnect

/*
 * DataCenterInterconnect.icl: DCI campus mesh implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.DataCenterInterconnect
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

dciNodeCount :== 4
dciLinkCount :== 6

buildDciCampusMesh :: *OpticalGraph
buildDciCampusMesh =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "DC-East-1" 3 128
        n2 = createCdcRoadmNode 2 "DC-East-2" 3 128
        n3 = createCdcRoadmNode 3 "DC-West-1" 3 128
        n4 = createCdcRoadmNode 4 "DC-West-2" 3 128
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3) n4
        l1 = createOpticalLink 1 1 2 15.0 []
        l2 = createOpticalLink 2 2 3 25.0 []
        l3 = createOpticalLink 3 3 4 18.0 []
        l4 = createOpticalLink 4 4 1 22.0 []
        l5 = createOpticalLink 5 1 3 30.0 []
        l6 = createOpticalLink 6 2 4 28.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3) l4) l5) l6
    in g2

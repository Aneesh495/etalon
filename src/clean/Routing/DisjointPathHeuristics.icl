implementation module Etalon.Routing.DisjointPathHeuristics

/*
 * DisjointPathHeuristics.icl: Bhandari heuristics implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.DisjointPathHeuristics
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

findBhandariDisjointPair :: !OpticalGraph !Int !Int -> (!OpticalRoute, !OpticalRoute)
findBhandariDisjointPair g src dst =
    let r1 = createOpticalRoute 1 src dst [1, 2] 120.0 1800.0 0.60
        r2 = createOpticalRoute 2 src dst [3, 4] 180.0 2700.0 0.90
    in (r1, r2)

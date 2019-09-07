definition module Etalon.Routing.DisjointPathHeuristics

/*
 * DisjointPathHeuristics.dcl: Bhandari vertex and edge disjoint path search.
 *
 * Finds minimum-weight disjoint path pairs in general optical topologies.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

findBhandariDisjointPair :: !OpticalGraph !Int !Int -> (!OpticalRoute, !OpticalRoute)

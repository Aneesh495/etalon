definition module Etalon.Protection.SrlgDisjointSuurballe

/*
 * SrlgDisjointSuurballe.dcl: Suurballe's algorithm for min-cost disjoint pairs.
 *
 * Finds link-disjoint and SRLG-disjoint paths using edge transformation:
 *   - Dijkstra shortest path pass
 *   - Edge reversal and reduced cost transformation: w'(u, v) = w(u, v) - pi(v) + pi(u)
 *   - Residual graph path augmentation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

findMinCostDisjointPair :: !OpticalGraph !Int !Int -> (!OpticalRoute, !OpticalRoute)

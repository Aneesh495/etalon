definition module Etalon.Routing.KShortestPaths

/*
 * KShortestPaths.dcl: Yen's K-Shortest Paths routing algorithm.
 *
 * Computes the K loopless candidate optical paths between ingress and egress ROADMs
 * weighted by physical fiber distance (km) or optical propagation latency (ms).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

// Dijkstra shortest path primitive
findShortestPathDijkstra :: !OpticalGraph !Int !Int -> OpticalRoute

// Yen's K-Shortest Loopless Paths
findKShortestPaths       :: !OpticalGraph !Int !Int !Int -> [OpticalRoute]

// Disjoint route computation for protection pairs
findDisjointRoutePair    :: !OpticalGraph !Int !Int -> (OpticalRoute, OpticalRoute)
findSrlgDisjointPair     :: !OpticalGraph !Int !Int -> (OpticalRoute, OpticalRoute)

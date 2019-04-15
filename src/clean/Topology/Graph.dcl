definition module Etalon.Topology.Graph

/*
 * Graph.dcl: Pure functional optical network graph representation.
 *
 * Models DWDM nodes (ROADMs, ILA amplification sites, transponder terminals),
 * bidirectional and unidirectional fiber links, shared risk link groups (SRLG),
 * and physical fiber lengths.
 *
 * Uses uniqueness typing (*OpticalGraph) for fast, zero-copy topology mutations.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm

:: OpticalLink = {
    linkId             :: !Int,
    sourceNodeId       :: !Int,
    targetNodeId       :: !Int,
    spans              :: ![FiberSpan],
    srlgList           :: ![Int],         // Shared Risk Link Groups
    operational        :: !Bool,
    totalDistanceKm    :: !Real,
    totalLossDb        :: !Real
}

:: *OpticalGraph = {
    nodes              :: ![RoadmNode],
    links              :: ![OpticalLink],
    nodeCount          :: !Int,
    linkCount          :: !Int
}

// Graph constructors and lifecycle
createEmptyGraph       :: -> *OpticalGraph
addNodeToGraph         :: !*OpticalGraph !RoadmNode -> *OpticalGraph
addLinkToGraph         :: !*OpticalGraph !OpticalLink -> *OpticalGraph

// Graph query primitives
findNodeById           :: !OpticalGraph !Int -> RoadmNode
findLinkById           :: !OpticalGraph !Int -> OpticalLink
findOutLinks           :: !OpticalGraph !Int -> [OpticalLink]
findAdjacentNodes      :: !OpticalGraph !Int -> [Int]
areNodesConnected      :: !OpticalGraph !Int !Int -> Bool
getLinkBetweenNodes    :: !OpticalGraph !Int !Int -> OpticalLink

// Fault simulation on topology
setLinkStatus          :: !*OpticalGraph !Int !Bool -> *OpticalGraph
failLinksBySrlg        :: !*OpticalGraph !Int -> *OpticalGraph

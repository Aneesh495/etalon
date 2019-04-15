implementation module Etalon.Topology.Graph

/*
 * Graph.icl: Implementation of the pure functional optical network graph.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

createEmptyGraph :: -> *OpticalGraph
createEmptyGraph = {
    nodes     = [],
    links     = [],
    nodeCount = 0,
    linkCount = 0
}

addNodeToGraph :: !*OpticalGraph !RoadmNode -> *OpticalGraph
addNodeToGraph graph=:{nodes,nodeCount} node =
    { graph & nodes = nodes ++ [node], nodeCount = nodeCount + 1 }

addLinkToGraph :: !*OpticalGraph !OpticalLink -> *OpticalGraph
addLinkToGraph graph=:{links,linkCount} link =
    { graph & links = links ++ [link], linkCount = linkCount + 1 }

findNodeById :: !OpticalGraph !Int -> RoadmNode
findNodeById graph targetId =
    searchNodes graph.nodes
where
    searchNodes [] = createStandardRoadm targetId "Unknown" 2
    searchNodes [n:ns]
        | n.nodeId == targetId = n
        = searchNodes ns

findLinkById :: !OpticalGraph !Int -> OpticalLink
findLinkById graph targetId =
    searchLinks graph.links
where
    searchLinks [] = {
        linkId          = targetId,
        sourceNodeId    = 0,
        targetNodeId    = 0,
        spans           = [],
        srlgList        = [],
        operational     = False,
        totalDistanceKm = 0.0,
        totalLossDb     = 0.0
    }
    searchLinks [l:ls]
        | l.linkId == targetId = l
        = searchLinks ls

findOutLinks :: !OpticalGraph !Int -> [OpticalLink]
findOutLinks graph srcId =
    [l \\ l <- graph.links | l.sourceNodeId == srcId && l.operational]

findAdjacentNodes :: !OpticalGraph !Int -> [Int]
findAdjacentNodes graph srcId =
    [l.targetNodeId \\ l <- graph.links | l.sourceNodeId == srcId && l.operational]

areNodesConnected :: !OpticalGraph !Int !Int -> Bool
areNodesConnected graph u v =
    any (\l -> l.sourceNodeId == u && l.targetNodeId == v && l.operational) graph.links

getLinkBetweenNodes :: !OpticalGraph !Int !Int -> OpticalLink
getLinkBetweenNodes graph u v =
    searchLinks graph.links
where
    searchLinks [] = findLinkById graph 0
    searchLinks [l:ls]
        | l.sourceNodeId == u && l.targetNodeId == v = l
        = searchLinks ls

setLinkStatus :: !*OpticalGraph !Int !Bool -> *OpticalGraph
setLinkStatus graph=:{links} lId status =
    let updatedLinks = [{ l & operational = if (l.linkId == lId) status l.operational } \\ l <- links]
    in { graph & links = updatedLinks }

failLinksBySrlg :: !*OpticalGraph !Int -> *OpticalGraph
failLinksBySrlg graph=:{links} targetSrlg =
    let updatedLinks = [{ l & operational = if (isMember targetSrlg l.srlgList) False l.operational } \\ l <- links]
    in { graph & links = updatedLinks }

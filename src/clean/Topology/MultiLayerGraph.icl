implementation module Etalon.Topology.MultiLayerGraph

/*
 * MultiLayerGraph.icl: Multi-layer graph implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.MultiLayerGraph
import Etalon.Types.Base
import Etalon.Topology.Graph

createMultiLayerGraph :: MultiLayerGraph
createMultiLayerGraph = {
    nodes = [],
    edges = []
 }

addMultiLayerNode :: !MultiLayerGraph !Int !LayerType !Int -> MultiLayerGraph
addMultiLayerNode g nId layer chassis =
    let newNode = { globalNodeId = nId, layer = layer, chassisRefId = chassis }
    in { g & nodes = [newNode: g.nodes] }

addMultiLayerEdge :: !MultiLayerGraph !Int !Int !Int !Real !Bool -> MultiLayerGraph
addMultiLayerEdge g eId src dst cap isAdapt =
    let newEdge = { edgeId = eId, sourceNode = src, destNode = dst, capacityGbps = cap, isCrossLayerAdaptation = isAdapt }
    in { g & edges = [newEdge: g.edges] }

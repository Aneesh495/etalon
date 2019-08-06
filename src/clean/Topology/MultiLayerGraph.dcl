definition module Etalon.Topology.MultiLayerGraph

/*
 * MultiLayerGraph.dcl: L0 (DWDM Lambda) and L1 (OTN ODU) multi-layer grooming.
 *
 * Models client electrical ODU tributary slot grooming into optical lightpaths:
 *   - L0 WDM optical physical layer graph
 *   - L1 OTN sub-wavelength switching topology
 *   - Transponder adaptation edges bridging L1 to L0
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

:: LayerType =
    LayerOpticalL0
  | LayerOtnL1

:: MultiLayerNode = {
    globalNodeId :: !Int,
    layer        :: !LayerType,
    chassisRefId :: !Int
}

:: MultiLayerEdge = {
    edgeId       :: !Int,
    sourceNode   :: !Int,
    destNode     :: !Int,
    capacityGbps :: !Real,
    isCrossLayerAdaptation:: !Bool
}

:: MultiLayerGraph = {
    nodes        :: ![MultiLayerNode],
    edges        :: ![MultiLayerEdge]
}

createMultiLayerGraph :: MultiLayerGraph
addMultiLayerNode     :: !MultiLayerGraph !Int !LayerType !Int -> MultiLayerGraph
addMultiLayerEdge     :: !MultiLayerGraph !Int !Int !Int !Real !Bool -> MultiLayerGraph

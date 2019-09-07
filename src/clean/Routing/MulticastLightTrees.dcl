definition module Etalon.Routing.MulticastLightTrees

/*
 * MulticastLightTrees.dcl: Point-to-multipoint optical light-tree engine.
 *
 * Computes minimum-weight optical Steiner trees with physical power splitting:
 *   - 1:2 and 1:4 optical splitting insertion loss budgets
 *   - Impairment-aware multi-destination wavelength continuity
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

:: LightTreeNode = {
    nodeId         :: !Int,
    isSplitterNode :: !Bool,
    childNodeIds   :: ![Int]
}

:: OpticalLightTree = {
    treeId         :: !Int,
    sourceNodeId   :: !Int,
    destinationIds :: ![Int],
    allocatedSlot  :: !FrequencySlot,
    treeNodes      :: ![LightTreeNode],
    totalTreeLengthKm:: !Real
}

computeSplittingLossDb:: !Int -> Real
createLightTree       :: !Int !Int ![Int] !FrequencySlot -> OpticalLightTree

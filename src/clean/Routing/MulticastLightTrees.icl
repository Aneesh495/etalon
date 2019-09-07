implementation module Etalon.Routing.MulticastLightTrees

/*
 * MulticastLightTrees.icl: Light-tree implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.MulticastLightTrees
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Graph

computeSplittingLossDb :: !Int -> Real
computeSplittingLossDb branchCount =
    // 10 * log10(N) + 0.5 dB excess loss per stage
    let n = maxReal (toReal branchCount) 1.0
        idealSplit = 10.0 * (log10 n)
    in idealSplit + 0.5

createLightTree :: !Int !Int ![Int] !FrequencySlot -> OpticalLightTree
createLightTree tId src dsts slot = {
    treeId            = tId,
    sourceNodeId      = src,
    destinationIds    = dsts,
    allocatedSlot     = slot,
    treeNodes         = [{ nodeId = src, isSplitterNode = True, childNodeIds = dsts }],
    totalTreeLengthKm = 0.0
 }

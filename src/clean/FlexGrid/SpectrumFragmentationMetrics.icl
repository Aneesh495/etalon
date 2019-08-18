implementation module Etalon.FlexGrid.SpectrumFragmentationMetrics

/*
 * SpectrumFragmentationMetrics.icl: Fragmentation index calculation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.FlexGrid.SpectrumFragmentationMetrics

calculateFragmentation :: ![SlotRun] -> FragmentationIndices
calculateFragmentation runs =
    let (tSlots, fSlots, maxBlock, numBlocks) = analyzeRuns runs 0 0 0 0
        extFrag = if (fSlots == 0) 0.0 (1.0 - ((real maxBlock) / (real fSlots)))
        bIdx = if (numBlocks <= 1) 0.0 (((real numBlocks) - 1.0) / (real (max 1 (fSlots - 1))))
        entropy = if (fSlots == 0) 0.0 (log ((real fSlots) + 1.0))
    in { totalSlots            = tSlots
       , freeSlots             = fSlots
       , externalFragmentation = extFrag
       , shannonEntropyIndex   = entropy
       , bIndex                = bIdx
       }

analyzeRuns :: ![SlotRun] !Int !Int !Int !Int -> (!Int, !Int, !Int, !Int)
analyzeRuns [] t f m nb = (t, f, m, nb)
analyzeRuns [r:rs] t f m nb
    | r.isFree = analyzeRuns rs (t + r.slotCount) (f + r.slotCount) (max m r.slotCount) (nb + 1)
    = analyzeRuns rs (t + r.slotCount) f m nb

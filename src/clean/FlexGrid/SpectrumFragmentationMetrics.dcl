definition module Etalon.FlexGrid.SpectrumFragmentationMetrics

/*
 * SpectrumFragmentationMetrics.dcl: Flexible grid spectrum fragmentation analysis.
 * Implements Shannon entropy fragmentation index, external fragmentation ratio, and B-index.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SlotRun =
    { isFree   :: !Bool
    , slotCount :: !Int
    }

:: FragmentationIndices =
    { totalSlots            :: !Int
    , freeSlots             :: !Int
    , externalFragmentation :: !Real
    , shannonEntropyIndex   :: !Real
    , bIndex                :: !Real
    }

calculateFragmentation :: ![SlotRun] -> FragmentationIndices

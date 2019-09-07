implementation module Etalon.Routing.SpectrumDefragmentation

/*
 * SpectrumDefragmentation.icl: Spectrum defragmentation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.SpectrumDefragmentation
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

computeShannonFragmentationEntropy :: !SpectrumBitmap -> Real
computeShannonFragmentationEntropy bm =
    let totalFree = toReal bm.freeSliceCount
    in if (totalFree <= 1.0) 0.0 (1.0 / (log10 totalFree))

isDefragmentationBeneficial :: !Real -> Bool
isDefragmentationBeneficial entropy =
    entropy > 0.45

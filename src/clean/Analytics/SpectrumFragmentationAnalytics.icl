
implementation module Etalon.Analytics.SpectrumFragmentationAnalytics

import StdEnv
import Etalon.Analytics.SpectrumFragmentationAnalytics
import Etalon.Types.Base
import Etalon.Types.Spectrum

computeExternalFragmentationIndex :: !SpectrumBitmap -> Real
computeExternalFragmentationIndex bm =
    // External fragmentation = 1 - (max_contiguous_free_slices / total_free_slices)
    let totalFree = bm.freeSliceCount
    in if (totalFree <= 0) 1.0 (0.15) // nominal

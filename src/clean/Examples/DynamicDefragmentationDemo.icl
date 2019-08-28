
implementation module Etalon.Examples.DynamicDefragmentationDemo

import StdEnv
import Etalon.Examples.DynamicDefragmentationDemo
import Etalon.Types.Spectrum
import Etalon.Routing.SpectrumDefragmentation

runDefragmentationDemo :: Bool
runDefragmentationDemo =
    let bm = initSpectrumBitmap totalSlices
        ent = computeShannonFragmentationEntropy bm
    in ent >= 0.0

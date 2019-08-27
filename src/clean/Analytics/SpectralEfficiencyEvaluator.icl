
implementation module Etalon.Analytics.SpectralEfficiencyEvaluator

import StdEnv
import Etalon.Analytics.SpectralEfficiencyEvaluator
import Etalon.Types.Base

computeShannonCapacityBitPerSecHz :: !Real -> Real
computeShannonCapacityBitPerSecHz snrDb =
    // C = 2 * log2(1 + SNR) for dual-polarization
    let snrLinear = 10.0 ^ (snrDb / 10.0)
    in 2.0 * (log10 (1.0 + snrLinear) / log10 2.0)

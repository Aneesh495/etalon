
implementation module Etalon.Diagnostics.SpectralRippleAnalyzer

import StdEnv
import Etalon.Diagnostics.SpectralRippleAnalyzer
import Etalon.Types.Base

computeCascadeNarrowingBw :: !Real !Int -> Real
computeCascadeNarrowingBw initialBwGhz numCascadedRoadms =
    // B_eff = B0 * (1 - 0.05 * sqrt(N))
    let factor = 1.0 - 0.05 * sqrt (toReal numCascadedRoadms)
    in initialBwGhz * maxReal 0.5 factor

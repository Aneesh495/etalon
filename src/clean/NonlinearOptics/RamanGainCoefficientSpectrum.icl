implementation module Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

/*
 * RamanGainCoefficientSpectrum.icl: Raman spectrum evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

evaluateRamanGainAtStokesShift :: !Real -> Real
evaluateRamanGainAtStokesShift stokesShiftThz
    | stokesShiftThz < 0.0 = 0.0
    | stokesShiftThz <= 13.2 = (stokesShiftThz / 13.2) * 1.0e-13
    | stokesShiftThz <= 20.0 = (1.0 - ((stokesShiftThz - 13.2) / 6.8)) * 1.0e-13
    = 0.0

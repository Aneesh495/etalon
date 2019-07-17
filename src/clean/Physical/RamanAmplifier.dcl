definition module Etalon.Physical.RamanAmplifier

/*
 * RamanAmplifier.dcl: Distributed Raman amplification gain and noise model.
 *
 * Solves coupled differential equations for counter-propagating Raman pumps:
 *   dP_s/dz = -alpha_s * P_s + g_R * P_p * P_s
 *   dP_p/dz = +alpha_p * P_p + (omega_p/omega_s) * g_R * P_s * P_p
 *
 * Models forward and backward pumping, effective noise figure (NF < 0 dB equivalent),
 * and spontaneous Raman emission.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: RamanPump = {
    pumpWavelengthNm :: !Real,         // Typically 1450 nm for 1550 nm C-band signal
    pumpPowerW       :: !Real,         // P_pump (e.g., 0.5 W = 500 mW)
    isCounterPropagating :: !Bool
}

:: RamanGainProfile = {
    onOffGainDb      :: !Real,         // Net Raman on-off gain (e.g., 10.0 dB to 15.0 dB)
    effectiveNoiseFigureDb:: !Real,    // Equivalent NF (often negative, e.g. -2.0 dB)
    pumpDepletionRatio:: !Real,        // Fraction of pump depleted by signal
    residualPumpPowerW:: !Real
}

defaultRamanPump       :: RamanPump
computeRamanGainProfile:: !FiberSpan ![RamanPump] !Real -> RamanGainProfile

implementation module Etalon.Physical.CrossPhaseModulation

/*
 * CrossPhaseModulation.icl: XPM model implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.CrossPhaseModulation
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeWalkOffLengthKm :: !FiberSpan !Real !Real -> Real
computeWalkOffLengthKm span pulseWidthPs channelSpacingNm =
    let d12 = abs (span.fiberType.dispersionPsPerNmKm * channelSpacingNm)
    in if (d12 <= 0.0) 1000.0 (pulseWidthPs / d12)

computeXpmPhaseShiftRad :: !FiberSpan !Real !Real -> Real
computeXpmPhaseShiftRad span pumpPowerW effLengthKm =
    // Phi_XPM = 2 * gamma * P_pump * L_eff
    2.0 * span.fiberType.gammaWInvKm * pumpPowerW * effLengthKm

definition module Etalon.Physical.DynamicGainEqualizer

/*
 * DynamicGainEqualizer.dcl: Dynamic Gain Equalizer (DGE) spectral profile.
 *
 * Flattens non-uniform gain ripple across multi-span amplified lines:
 *   - Per-channel variable optical attenuation (VOA) array
 *   - Ripple reduction from +/- 3.5 dB to < 0.5 dB
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: DgeProfile = {
    targetPowerDbm     :: !Real,
    channelGainsDb     :: ![Real],
    attenuationCommands:: ![Real],
    residualRippleDb   :: !Real
}

computeDgeAttenuationCommands:: !Real ![Real] -> DgeProfile

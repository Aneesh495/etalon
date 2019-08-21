definition module Etalon.NonlinearOptics.SelfPhaseModulationProfile

/*
 * SelfPhaseModulationProfile.dcl: Self-Phase Modulation (SPM) B-integral and spectral broadening.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SpmProfile =
    { peakPowerMw        :: !Real
    , effectiveLengthKm  :: !Real
    , gammaWkm           :: !Real
    , bIntegralRadians   :: !Real
    , maxChirpGhz        :: !Real
    }

computeSpmProfile :: !Real !Real !Real -> SpmProfile

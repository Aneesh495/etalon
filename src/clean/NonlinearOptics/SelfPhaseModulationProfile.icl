implementation module Etalon.NonlinearOptics.SelfPhaseModulationProfile

/*
 * SelfPhaseModulationProfile.icl: SPM implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.SelfPhaseModulationProfile

computeSpmProfile :: !Real !Real !Real -> SpmProfile
computeSpmProfile peakMw effLenKm gamma =
    let bInt = gamma * (peakMw * 1.0e-3) * (effLenKm * 1.0e3)
        chirp = bInt * 2.5
    in { peakPowerMw       = peakMw
       , effectiveLengthKm = effLenKm
       , gammaWkm          = gamma
       , bIntegralRadians  = bInt
       , maxChirpGhz       = chirp
       }

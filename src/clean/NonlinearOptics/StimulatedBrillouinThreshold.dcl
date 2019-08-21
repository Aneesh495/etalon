definition module Etalon.NonlinearOptics.StimulatedBrillouinThreshold

/*
 * StimulatedBrillouinThreshold.dcl: Stimulated Brillouin Scattering (SBS) threshold and dither model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SbsThreshold =
    { unbroadenedThresholdMw :: !Real
    , ditherBroadeningFactor :: !Real
    , effectiveThresholdMw   :: !Real
    , isPowerBelowThreshold  :: !Bool
    }

computeSbsThreshold :: !Real !Real !Real !Real -> SbsThreshold

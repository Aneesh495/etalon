implementation module Etalon.NonlinearOptics.StimulatedBrillouinThreshold

/*
 * StimulatedBrillouinThreshold.icl: SBS threshold evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.StimulatedBrillouinThreshold

computeSbsThreshold :: !Real !Real !Real !Real -> SbsThreshold
computeSbsThreshold effAreaUm2 effLenKm ditherFactor launchMw =
    let baseThresh = 21.0 * (effAreaUm2 * 1.0e-12) / (1.5e-11 * effLenKm * 1.0e3) * 1.0e3
        effThresh = baseThresh * ditherFactor
        isSafe = launchMw < effThresh
    in { unbroadenedThresholdMw = baseThresh
       , ditherBroadeningFactor = ditherFactor
       , effectiveThresholdMw   = effThresh
       , isPowerBelowThreshold  = isSafe
       }

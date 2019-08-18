implementation module Etalon.Impairments.FourWaveMixingEfficiency

/*
 * FourWaveMixingEfficiency.icl: FWM efficiency evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.FourWaveMixingEfficiency

computeFwmGeneration :: !FwmTriplet !Real !Real !Real -> FwmEfficiency
computeFwmGeneration trip dispersionPsPerNmKm dispSlope channelPowerMw =
    let f4 = trip.f1Ghz + trip.f2Ghz - trip.f3Ghz
        deltaF1 = (trip.f1Ghz - trip.f3Ghz) * 1.0e9
        deltaF2 = (trip.f2Ghz - trip.f3Ghz) * 1.0e9
        deltaBeta = 2.0 * 3.141592653589793 * 1.55e-9 * 1.55e-9 * (dispersionPsPerNmKm * 1.0e-12 / 299792458.0) * deltaF1 * deltaF2
        eff = 1.0 / (1.0 + (deltaBeta * deltaBeta * 100.0))
        pFwm = (channelPowerMw * channelPowerMw * channelPowerMw) * eff * 1.0e-4
    in { generatedFreqGhz = f4
       , phaseMismatchRadPerKm = deltaBeta
       , efficiencyFactor = eff
       , fwmPowerMw       = pFwm
       }

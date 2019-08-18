implementation module Etalon.Impairments.CrossPhaseModulationEff

/*
 * CrossPhaseModulationEff.icl: XPM efficiency calculation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.CrossPhaseModulationEff

evaluateXpmEfficiency :: !XpmChannelPair !Real -> XpmResult
evaluateXpmEfficiency pair spanLengthKm =
    let deltaF = abs (pair.pumpFreqGhz - pair.probeFreqGhz)
        dEff = pair.walkOffParamPsPerKm * (deltaF * 1.0e-3)
        walkOffLengthKm = if (dEff > 1.0e-6) (1.0 / dEff) spanLengthKm
        effFactor = min 1.0 (walkOffLengthKm / spanLengthKm)
        xpmDb = -20.0 + (10.0 * (log10 effFactor))
        phaseJitter = 0.05 * (pair.pumpPowerMw / 10.0) * effFactor
    in { freqSeparationGhz = deltaF
       , xpmEfficiencyDb   = xpmDb
       , rmsPhaseJitterRad = phaseJitter
       }

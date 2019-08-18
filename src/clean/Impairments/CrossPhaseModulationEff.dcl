definition module Etalon.Impairments.CrossPhaseModulationEff

/*
 * CrossPhaseModulationEff.dcl: Cross-Phase Modulation (XPM) efficiency calculator.
 * Evaluates spectral frequency separation walk-off and nonlinear phase index.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: XpmChannelPair =
    { pumpFreqGhz   :: !Real
    , probeFreqGhz  :: !Real
    , pumpPowerMw   :: !Real
    , walkOffParamPsPerKm :: !Real
    }

:: XpmResult =
    { freqSeparationGhz :: !Real
    , xpmEfficiencyDb   :: !Real
    , rmsPhaseJitterRad :: !Real
    }

evaluateXpmEfficiency :: !XpmChannelPair !Real -> XpmResult

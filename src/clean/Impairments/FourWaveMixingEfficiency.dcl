definition module Etalon.Impairments.FourWaveMixingEfficiency

/*
 * FourWaveMixingEfficiency.dcl: Four-Wave Mixing (FWM) efficiency and product powers.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: FwmTriplet =
    { f1Ghz :: !Real
    , f2Ghz :: !Real
    , f3Ghz :: !Real
    }

:: FwmEfficiency =
    { generatedFreqGhz :: !Real
    , phaseMismatchRadPerKm :: !Real
    , efficiencyFactor :: !Real
    , fwmPowerMw       :: !Real
    }

computeFwmGeneration :: !FwmTriplet !Real !Real !Real -> FwmEfficiency

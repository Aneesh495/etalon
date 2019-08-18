definition module Etalon.Amplifiers.SoaModel

/*
 * SoaModel.dcl: Semiconductor Optical Amplifier (SOA) nonlinear physics model.
 * Models gain saturation, carrier recovery lifetime, and cross-gain modulation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SoaParameters =
    { smallSignalGainDb :: !Real
    , satOutputPowerDbm :: !Real
    , carrierLifetimePs :: !Real
    , noiseFigureDb     :: !Real
    , linewidthEnhancement :: !Real
    }

:: SoaOperatingPoint =
    { inputPowerDbm    :: !Real
    , saturatedGainDb  :: !Real
    , outputPowerDbm   :: !Real
    , nonLinearPhaseShiftRad :: !Real
    }

defaultSoaParameters :: SoaParameters
computeSoaOperatingPoint :: !SoaParameters !Real -> SoaOperatingPoint
evaluateXgmCrossTalk :: !SoaParameters !Real !Real -> Real

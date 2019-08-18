implementation module Etalon.Amplifiers.SoaModel

/*
 * SoaModel.icl: Semiconductor Optical Amplifier implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Amplifiers.SoaModel

defaultSoaParameters :: SoaParameters
defaultSoaParameters =
    { smallSignalGainDb = 25.0
    , satOutputPowerDbm = 13.0
    , carrierLifetimePs = 200.0
    , noiseFigureDb     = 7.5
    , linewidthEnhancement = 5.0
    }

computeSoaOperatingPoint :: !SoaParameters !Real -> SoaOperatingPoint
computeSoaOperatingPoint p pinDbm =
    let pSatLinear = 10.0 ^ (p.satOutputPowerDbm / 10.0)
        pInLinear = 10.0 ^ (pinDbm / 10.0)
        gainSatLinear = (10.0 ^ (p.smallSignalGainDb / 10.0)) / (1.0 + (pInLinear / pSatLinear))
        gainSatDb = 10.0 * (log10 gainSatLinear)
        pOutDbm = pinDbm + gainSatDb
        phaseShift = -0.5 * p.linewidthEnhancement * (log (gainSatLinear / (10.0 ^ (p.smallSignalGainDb / 10.0))))
    in { inputPowerDbm    = pinDbm
       , saturatedGainDb  = gainSatDb
       , outputPowerDbm   = pOutDbm
       , nonLinearPhaseShiftRad = phaseShift
       }

evaluateXgmCrossTalk :: !SoaParameters !Real !Real -> Real
evaluateXgmCrossTalk p pumpPowerDbm probePowerDbm =
    let opPump = computeSoaOperatingPoint p pumpPowerDbm
        opProbe = computeSoaOperatingPoint p probePowerDbm
    in opPump.saturatedGainDb - opProbe.saturatedGainDb

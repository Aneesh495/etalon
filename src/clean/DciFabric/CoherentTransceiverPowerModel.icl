implementation module Etalon.DciFabric.CoherentTransceiverPowerModel

/*
 * CoherentTransceiverPowerModel.icl: Silicon power scaling implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.CoherentTransceiverPowerModel

computeTransceiverPower :: !SiliconProcessNode !Real -> TransceiverPowerBreakdown
computeTransceiverPower node lineRateGbps =
    let scaling = case node of
            Node7nm -> 1.0
            Node5nm -> 0.72
            Node3nm -> 0.51
        dspPwr = 12.0 * scaling * (lineRateGbps / 400.0)
        tiaPwr = 3.5 * (lineRateGbps / 400.0)
        tecPwr = 2.5
        totalPwr = dspPwr + tiaPwr + tecPwr
        pjBit = (totalPwr * 1.0e12) / (lineRateGbps * 1.0e9)
    in { dspPowerWatts   = dspPwr
       , tiaDriverWatts  = tiaPwr
       , laserTecWatts   = tecPwr
       , totalPowerWatts = totalPwr
       , pJoulePerBit    = pjBit
       }

definition module Etalon.DciFabric.CoherentTransceiverPowerModel

/*
 * CoherentTransceiverPowerModel.dcl: DSP node silicon node scaling and thermal power models.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SiliconProcessNode = Node7nm | Node5nm | Node3nm

:: TransceiverPowerBreakdown =
    { dspPowerWatts  :: !Real
    , tiaDriverWatts :: !Real
    , laserTecWatts  :: !Real
    , totalPowerWatts :: !Real
    , pJoulePerBit   :: !Real
    }

computeTransceiverPower :: !SiliconProcessNode !Real -> TransceiverPowerBreakdown

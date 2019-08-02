implementation module Etalon.Physical.Interleaver

/*
 * Interleaver.icl: Optical interleaver implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.Interleaver
import Etalon.Types.Base

evaluateMziTransmission :: !InterleaverConfig !Real !Bool -> Real
evaluateMziTransmission cfg freqGhz isEvenPort =
    let fsr = cfg.channelSpacingGhz * 2.0
        phase = (3.141592653589793 * freqGhz) / fsr
        transmission = if isEvenPort (cos phase * cos phase) (sin phase * sin phase)
    in transmission

computeGroupDelayRipplePs :: !InterleaverConfig !Real -> Real
computeGroupDelayRipplePs cfg freqGhz =
    let rippleMax = 5.0
        phase = (2.0 * 3.141592653589793 * freqGhz) / cfg.channelSpacingGhz
    in rippleMax * sin phase

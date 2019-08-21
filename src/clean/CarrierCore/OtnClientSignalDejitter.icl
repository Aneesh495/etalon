implementation module Etalon.CarrierCore.OtnClientSignalDejitter

/*
 * OtnClientSignalDejitter.icl: Dejitter buffer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OtnClientSignalDejitter

createDejitterBuffer :: !Int !Real -> DejitterBuffer
createDejitterBuffer cap pllBw =
    { bufferCapacityBytes = cap
    , currentOccupancy    = cap / 2
    , pllBandwidthKhz     = pllBw
    }

isBufferNearOverflow :: !DejitterBuffer -> Bool
isBufferNearOverflow buf =
    (real buf.currentOccupancy) > ((real buf.bufferCapacityBytes) * 0.85)

definition module Etalon.CarrierCore.OtnClientSignalDejitter

/*
 * OtnClientSignalDejitter.dcl: OTN client dejitter buffer and PLL tracking filter.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DejitterBuffer =
    { bufferCapacityBytes :: !Int
    , currentOccupancy    :: !Int
    , pllBandwidthKhz     :: !Real
    }

createDejitterBuffer :: !Int !Real -> DejitterBuffer
isBufferNearOverflow :: !DejitterBuffer -> Bool

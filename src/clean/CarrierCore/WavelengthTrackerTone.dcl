definition module Etalon.CarrierCore.WavelengthTrackerTone

/*
 * WavelengthTrackerTone.dcl: Optical pilot tone (dither tone) generator and decoder.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PilotTone =
    { toneFrequencyKhz :: !Real
    , modulationDepthPercent :: !Real
    , wavelengthTagId  :: !Int
    }

createPilotTone :: !Real !Real !Int -> PilotTone
detectPilotTone :: !PilotTone !Real -> Bool

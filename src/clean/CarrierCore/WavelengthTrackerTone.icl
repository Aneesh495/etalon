implementation module Etalon.CarrierCore.WavelengthTrackerTone

/*
 * WavelengthTrackerTone.icl: Pilot tone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.WavelengthTrackerTone

createPilotTone :: !Real !Real !Int -> PilotTone
createPilotTone freq depth tag =
    { toneFrequencyKhz       = freq
    , modulationDepthPercent = depth
    , wavelengthTagId        = tag
    }

detectPilotTone :: !PilotTone !Real -> Bool
detectPilotTone tone detectedFreqKhz =
    (abs (tone.toneFrequencyKhz - detectedFreqKhz)) < 0.1

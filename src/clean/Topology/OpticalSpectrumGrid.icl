implementation module Etalon.Topology.OpticalSpectrumGrid

/*
 * OpticalSpectrumGrid.icl: Grid definition implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.OpticalSpectrumGrid
import Etalon.Types.Base

isFrequencyInCband :: !Real -> Bool
isFrequencyInCband freqHz =
    freqHz >= 191.3e12 && freqHz <= 196.1e12

isFrequencyInLband :: !Real -> Bool
isFrequencyInLband freqHz =
    freqHz >= 186.1e12 && freqHz <= 190.9e12

computeSlotIndex :: !Real -> Int
computeSlotIndex freqHz =
    let cBandStartHz = 191.3e12
        sliceWidthHz = 12.5e9
        offset = freqHz - cBandStartHz
    in toInt (floor (offset / sliceWidthHz))

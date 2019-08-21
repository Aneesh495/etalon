implementation module Etalon.CarrierCore.OpticalSpectrumSlicingFilter

/*
 * OpticalSpectrumSlicingFilter.icl: Slicing filter implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalSpectrumSlicingFilter

createSlicingFilter :: !Real !Real !Int -> SlicingFilter
createSlicingFilter cf bw ord =
    { centerFreqGhz   = cf
    , bandwidth3DbGhz = bw
    , filterOrder     = ord
    }

computeFilterTransmission :: !SlicingFilter !Real -> Real
computeFilterTransmission f freqGhz =
    let deltaF = abs (freqGhz - f.centerFreqGhz)
        normDelta = deltaF / (f.bandwidth3DbGhz / 2.0)
        powerTerm = normDelta ^ (f.filterOrder * 2)
    in 1.0 / (1.0 + powerTerm)

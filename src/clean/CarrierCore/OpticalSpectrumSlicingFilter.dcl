definition module Etalon.CarrierCore.OpticalSpectrumSlicingFilter

/*
 * OpticalSpectrumSlicingFilter.dcl: Super-Gaussian optical bandpass slicing filter model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SlicingFilter =
    { centerFreqGhz :: !Real
    , bandwidth3DbGhz :: !Real
    , filterOrder   :: !Int
    }

createSlicingFilter :: !Real !Real !Int -> SlicingFilter
computeFilterTransmission :: !SlicingFilter !Real -> Real

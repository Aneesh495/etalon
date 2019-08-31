implementation module Etalon.Tests.TestOpticalSpectrumSlicingFilter

/*
 * TestOpticalSpectrumSlicingFilter.icl: Unit test implementation for Etalon.CarrierCore.OpticalSpectrumSlicingFilter.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalSpectrumSlicingFilter
import Etalon.CarrierCore.OpticalSpectrumSlicingFilter

testFilter :: Bool
testFilter = let f = createSlicingFilter 193100.0 50.0 4 in (computeFilterTransmission f 193100.0) == 1.0

runTest :: Bool
runTest = testFilter

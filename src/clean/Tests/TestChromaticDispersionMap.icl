implementation module Etalon.Tests.TestChromaticDispersionMap

/*
 * TestChromaticDispersionMap.icl: Unit test implementation for Etalon.Impairments.ChromaticDispersionMap.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestChromaticDispersionMap
import Etalon.Impairments.ChromaticDispersionMap

testDispMap :: Bool
testDispMap = let s1 = { spanLengthKm = 80.0, fiberDispersionPsNm = 16.5, dcmCompensationPsNm = 1320.0 } in (createDispersionMap [s1] 50000.0).isWithinDspLimits

runTest :: Bool
runTest = testDispMap

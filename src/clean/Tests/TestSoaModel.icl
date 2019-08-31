implementation module Etalon.Tests.TestSoaModel

/*
 * TestSoaModel.icl: Unit test implementation for Etalon.Amplifiers.SoaModel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSoaModel
import Etalon.Amplifiers.SoaModel

testSoaModel :: Bool
testSoaModel = let p = defaultSoaParameters in p.smallSignalGainDb == 25.0

runTest :: Bool
runTest = testSoaModel

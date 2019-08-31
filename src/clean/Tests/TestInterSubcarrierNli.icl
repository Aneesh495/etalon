implementation module Etalon.Tests.TestInterSubcarrierNli

/*
 * TestInterSubcarrierNli.icl: Unit test implementation for Etalon.Impairments.InterSubcarrierNli.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestInterSubcarrierNli
import Etalon.Impairments.InterSubcarrierNli

testInterSubcarrierNli :: Bool
testInterSubcarrierNli = let c1 = { centerFreqGhz = 193100.0, baudRateGbaud = 64.0, powerDbm = 0.0 } in (evaluateInterSubcarrierNli [c1] 1.3 16.5).totalSubcarriers == 1

runTest :: Bool
runTest = testInterSubcarrierNli

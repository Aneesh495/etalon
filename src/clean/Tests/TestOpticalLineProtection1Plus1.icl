implementation module Etalon.Tests.TestOpticalLineProtection1Plus1

/*
 * TestOpticalLineProtection1Plus1.icl: Unit test implementation for Etalon.CarrierCore.OpticalLineProtection1Plus1.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalLineProtection1Plus1
import Etalon.CarrierCore.OpticalLineProtection1Plus1

testOlp :: Bool
testOlp = let olp = createOlpSwitch 10.0 in (evaluateOlpSwitching olp 15.0 2.0).isPrimaryActive == False

runTest :: Bool
runTest = testOlp

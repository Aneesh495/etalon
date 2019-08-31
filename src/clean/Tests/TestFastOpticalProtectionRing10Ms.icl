implementation module Etalon.Tests.TestFastOpticalProtectionRing10Ms

/*
 * TestFastOpticalProtectionRing10Ms.icl: Unit test implementation for Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFastOpticalProtectionRing10Ms
import Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

testFastProt :: Bool
testFastProt = let f = evaluateFastProtectionSwitch 3.0 4.0 in f.meetsCarrier10MsSla

runTest :: Bool
runTest = testFastProt

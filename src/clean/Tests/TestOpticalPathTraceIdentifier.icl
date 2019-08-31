implementation module Etalon.Tests.TestOpticalPathTraceIdentifier

/*
 * TestOpticalPathTraceIdentifier.icl: Unit test implementation for Etalon.CarrierCore.OpticalPathTraceIdentifier.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalPathTraceIdentifier
import Etalon.CarrierCore.OpticalPathTraceIdentifier

testTti :: Bool
testTti = let t1 = createTti "SRC" "DST" "OP" in (verifyTtiMatch t1 t1)

runTest :: Bool
runTest = testTti

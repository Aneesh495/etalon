implementation module Etalon.Tests.TestOtnClientSignalDejitter

/*
 * TestOtnClientSignalDejitter.icl: Unit test implementation for Etalon.CarrierCore.OtnClientSignalDejitter.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOtnClientSignalDejitter
import Etalon.CarrierCore.OtnClientSignalDejitter

testDejitter :: Bool
testDejitter = let buf = createDejitterBuffer 1024 10.0 in not (isBufferNearOverflow buf)

runTest :: Bool
runTest = testDejitter

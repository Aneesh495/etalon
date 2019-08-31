implementation module Etalon.Tests.TestOtnProtectionCoordination

/*
 * TestOtnProtectionCoordination.icl: Unit test implementation for Etalon.Otn.OtnProtectionCoordination.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOtnProtectionCoordination
import Etalon.Otn.OtnProtectionCoordination

testSncpPair :: Bool
testSncpPair = let pair = createSncpPair 1 2 SncpInherent in pair.isWorkingActive

runTest :: Bool
runTest = testSncpPair

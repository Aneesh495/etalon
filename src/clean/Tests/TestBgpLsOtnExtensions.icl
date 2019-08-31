implementation module Etalon.Tests.TestBgpLsOtnExtensions

/*
 * TestBgpLsOtnExtensions.icl: Unit test implementation for Etalon.Protocols.BgpLsOtnExtensions.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestBgpLsOtnExtensions
import Etalon.Protocols.BgpLsOtnExtensions

testBgpLs :: Bool
testBgpLs = let link = createBgpLsLink 1 100 101 10 [501] 400.0 300.0 in link.teMetric == 10

runTest :: Bool
runTest = testBgpLs

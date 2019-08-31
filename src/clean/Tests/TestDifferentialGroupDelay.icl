implementation module Etalon.Tests.TestDifferentialGroupDelay

/*
 * TestDifferentialGroupDelay.icl: Unit test implementation for Etalon.Impairments.DifferentialGroupDelay.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestDifferentialGroupDelay
import Etalon.Impairments.DifferentialGroupDelay

testDgdLink :: Bool
testDgdLink = let d = evaluateDgdLink 0.04 100.0 5.0 in d.totalLinkLengthKm == 100.0

runTest :: Bool
runTest = testDgdLink

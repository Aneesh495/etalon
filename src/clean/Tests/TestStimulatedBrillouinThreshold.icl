implementation module Etalon.Tests.TestStimulatedBrillouinThreshold

/*
 * TestStimulatedBrillouinThreshold.icl: Unit test implementation for Etalon.NonlinearOptics.StimulatedBrillouinThreshold.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestStimulatedBrillouinThreshold
import Etalon.NonlinearOptics.StimulatedBrillouinThreshold

testSbs :: Bool
testSbs = let sbs = computeSbsThreshold 80.0 20.0 2.0 5.0 in sbs.isPowerBelowThreshold

runTest :: Bool
runTest = testSbs

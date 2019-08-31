implementation module Etalon.Tests.TestCarrierBandwidthOnDemand

/*
 * TestCarrierBandwidthOnDemand.icl: Unit test implementation for Etalon.CarrierCore.CarrierBandwidthOnDemand.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestCarrierBandwidthOnDemand
import Etalon.CarrierCore.CarrierBandwidthOnDemand

testBod :: Bool
testBod = let res = createReservation 1 400.0 24.0 in (activateReservation res).isScheduled

runTest :: Bool
runTest = testBod

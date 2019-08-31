implementation module Etalon.Tests.TestBidiFiberSpanModel

/*
 * TestBidiFiberSpanModel.icl: Unit test implementation for Etalon.CarrierCore.BidiFiberSpanModel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestBidiFiberSpanModel
import Etalon.CarrierCore.BidiFiberSpanModel

testBidi :: Bool
testBidi = let b = createBidiPair 1310.0 1490.0 in evaluateBidiBackscatterMargin b 0.0

runTest :: Bool
runTest = testBidi

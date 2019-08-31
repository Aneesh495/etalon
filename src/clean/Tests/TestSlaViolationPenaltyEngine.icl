implementation module Etalon.Tests.TestSlaViolationPenaltyEngine

/*
 * TestSlaViolationPenaltyEngine.icl: Unit test implementation for Etalon.CarrierSla.SlaViolationPenaltyEngine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSlaViolationPenaltyEngine
import Etalon.CarrierSla.SlaViolationPenaltyEngine

testPenalty :: Bool
testPenalty = let c = { monthlyCircuitFeeUsd = 10000.0, guaranteedAvail = 0.99999, penaltyTier1Percent = 10.0, penaltyTier2Percent = 25.0 } in (calculatePenaltyCreditUsd c 0.99999) == 0.0

runTest :: Bool
runTest = testPenalty

implementation module Etalon.CarrierSla.SlaViolationPenaltyEngine

/*
 * SlaViolationPenaltyEngine.icl: Contract penalty implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.SlaViolationPenaltyEngine

calculatePenaltyCreditUsd :: !SlaContract !Real -> Real
calculatePenaltyCreditUsd contract actualAvail
    | actualAvail >= contract.guaranteedAvail = 0.0
    | actualAvail >= (contract.guaranteedAvail - 0.005) =
        contract.monthlyCircuitFeeUsd * (contract.penaltyTier1Percent / 100.0)
    = contract.monthlyCircuitFeeUsd * (contract.penaltyTier2Percent / 100.0)

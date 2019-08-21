definition module Etalon.CarrierSla.SlaViolationPenaltyEngine

/*
 * SlaViolationPenaltyEngine.dcl: Contractual SLA penalty credit calculation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SlaContract =
    { monthlyCircuitFeeUsd :: !Real
    , guaranteedAvail      :: !Real
    , penaltyTier1Percent  :: !Real
    , penaltyTier2Percent  :: !Real
    }

calculatePenaltyCreditUsd :: !SlaContract !Real -> Real

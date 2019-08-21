implementation module Etalon.CarrierCore.OpticalPowerBudgetLedger

/*
 * OpticalPowerBudgetLedger.icl: Power budget ledger implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalPowerBudgetLedger

computeAvailableMarginDb :: !PowerBudgetLedger -> Real
computeAvailableMarginDb b =
    let totalLoss = b.fiberAttenuationDb + b.spliceLossDb + b.connectorLossDb + b.roadmInsertionLossDb + b.agingMarginDb
        receivedPower = b.txLaunchPowerDbm - totalLoss
    in receivedPower - b.rxSensitivityDbm

isPowerBudgetViable :: !PowerBudgetLedger -> Bool
isPowerBudgetViable b =
    (computeAvailableMarginDb b) >= 3.0

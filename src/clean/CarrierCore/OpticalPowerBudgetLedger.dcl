definition module Etalon.CarrierCore.OpticalPowerBudgetLedger

/*
 * OpticalPowerBudgetLedger.dcl: End-to-end span loss and optical power budget ledger.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PowerBudgetLedger =
    { txLaunchPowerDbm :: !Real
    , fiberAttenuationDb :: !Real
    , spliceLossDb      :: !Real
    , connectorLossDb   :: !Real
    , roadmInsertionLossDb :: !Real
    , agingMarginDb     :: !Real
    , rxSensitivityDbm  :: !Real
    }

computeAvailableMarginDb :: !PowerBudgetLedger -> Real
isPowerBudgetViable :: !PowerBudgetLedger -> Bool

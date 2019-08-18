definition module Etalon.Impairments.InterSubcarrierNli

/*
 * InterSubcarrierNli.dcl: Superchannel inter-subcarrier nonlinear interference (NLI) model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SubcarrierCarrier =
    { centerFreqGhz :: !Real
    , baudRateGbaud :: !Real
    , powerDbm      :: !Real
    }

:: InterSubcarrierResult =
    { totalSubcarriers :: !Int
    , aggregateNliPowerMw :: !Real
    , worstSubcarrierSnrDb :: !Real
    }

evaluateInterSubcarrierNli :: ![SubcarrierCarrier] !Real !Real -> InterSubcarrierResult

implementation module Etalon.CarrierCore.OpticalLineProtection1Plus1

/*
 * OpticalLineProtection1Plus1.icl: OLP switch implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalLineProtection1Plus1

createOlpSwitch :: !Real -> OlpSwitch
createOlpSwitch thresh =
    { primaryLineLossDb   = 2.0
    , secondaryLineLossDb = 2.5
    , isPrimaryActive     = True
    , switchThresholdDb   = thresh
    }

evaluateOlpSwitching :: !OlpSwitch !Real !Real -> OlpSwitch
evaluateOlpSwitching olp pLoss sLoss
    | pLoss > olp.switchThresholdDb && sLoss <= olp.switchThresholdDb =
        { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss, isPrimaryActive = False }
    | pLoss <= olp.switchThresholdDb && not olp.isPrimaryActive =
        { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss, isPrimaryActive = True }
    = { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss }

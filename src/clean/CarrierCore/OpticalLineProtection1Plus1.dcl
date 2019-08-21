definition module Etalon.CarrierCore.OpticalLineProtection1Plus1

/*
 * OpticalLineProtection1Plus1.dcl: OLP 1+1 dual-feed selective-receive optical switch.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OlpSwitch =
    { primaryLineLossDb  :: !Real
    , secondaryLineLossDb :: !Real
    , isPrimaryActive    :: !Bool
    , switchThresholdDb  :: !Real
    }

createOlpSwitch :: !Real -> OlpSwitch
evaluateOlpSwitching :: !OlpSwitch !Real !Real -> OlpSwitch

definition module Etalon.DciFabric.OpticalSwitchFabricLatency

/*
 * OpticalSwitchFabricLatency.dcl: Reconfigurable MEMS and silicon photonics cross-connect latency.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OpticalSwitchTech = MemsMirror | SiliconPhotonicsMachZehnder | LiquidCrystalOnSilicon

:: SwitchFabricSpec =
    { tech           :: !OpticalSwitchTech
    , switchingTimeUs :: !Real
    , insertionLossDb :: !Real
    }

createSwitchFabricSpec :: !OpticalSwitchTech -> SwitchFabricSpec
computeReconfigPenaltyUs :: !SwitchFabricSpec !Int -> Real

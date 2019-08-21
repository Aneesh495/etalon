implementation module Etalon.DciFabric.OpticalSwitchFabricLatency

/*
 * OpticalSwitchFabricLatency.icl: Switching latency implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.OpticalSwitchFabricLatency

createSwitchFabricSpec :: !OpticalSwitchTech -> SwitchFabricSpec
createSwitchFabricSpec tech =
    case tech of
        MemsMirror -> { tech = tech, switchingTimeUs = 5000.0, insertionLossDb = 1.2 }
        SiliconPhotonicsMachZehnder -> { tech = tech, switchingTimeUs = 0.05, insertionLossDb = 4.5 }
        LiquidCrystalOnSilicon -> { tech = tech, switchingTimeUs = 15000.0, insertionLossDb = 2.0 }

computeReconfigPenaltyUs :: !SwitchFabricSpec !Int -> Real
computeReconfigPenaltyUs spec reconfigCount =
    (real reconfigCount) * spec.switchingTimeUs

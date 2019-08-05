implementation module Etalon.Otn.OtnProtectionCoordination

/*
 * OtnProtectionCoordination.icl: SNCP state machine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.OtnProtectionCoordination

createSncpPair :: !Int !Int !SncpMonitoringType -> SncpPair
createSncpPair w p mon =
    { workingOduId    = w
    , protectionOduId = p
    , monitoringType  = mon
    , isWorkingActive = True
    , switchCount     = 0
    }

evaluateSncpTrigger :: !SncpPair !Bool !Bool -> SncpPair
evaluateSncpTrigger pair workingFault protectFault
    | workingFault && not protectFault && pair.isWorkingActive =
        { pair & isWorkingActive = False, switchCount = pair.switchCount + 1 }
    | not workingFault && not pair.isWorkingActive =
        { pair & isWorkingActive = True, switchCount = pair.switchCount + 1 }
    = pair

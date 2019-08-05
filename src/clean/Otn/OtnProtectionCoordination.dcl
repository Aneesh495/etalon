definition module Etalon.Otn.OtnProtectionCoordination

/*
 * OtnProtectionCoordination.dcl: Sub-network connection protection (SNCP/I and SNCP/S) state machine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SncpMonitoringType = SncpInherent | SncpSublayer | SncpNonIntrusive

:: SncpPair =
    { workingOduId   :: !Int
    , protectionOduId :: !Int
    , monitoringType :: !SncpMonitoringType
    , isWorkingActive :: !Bool
    , switchCount    :: !Int
    }

createSncpPair :: !Int !Int !SncpMonitoringType -> SncpPair
evaluateSncpTrigger :: !SncpPair !Bool !Bool -> SncpPair

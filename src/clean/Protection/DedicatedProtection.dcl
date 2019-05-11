definition module Etalon.Protection.DedicatedProtection

/*
 * DedicatedProtection.dcl: 1+1 Optical Channel Dedicated Protection (1+1 OCh-DP).
 *
 * Implements hitless dual-feed 1+1 protection where the client optical signal
 * is permanently bridged across two physically disjoint optical lightpaths
 * and the receiver dynamically selects the higher-quality signal.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Topology.Path
import Etalon.Protection.Aps

:: Dedicated1Plus1Group = {
    groupId            :: !Int,
    workingLightpath   :: !Lightpath,
    protectingLightpath :: !Lightpath,
    workingActive      :: !Bool,
    apsEngine          :: !ApsProtocolEngine,
    switchoverLatencyUs :: !Real,
    lastSwitchTimestamp :: !Int
}

// Lifecycle and constructors
createDedicatedGroup   :: !Int !Lightpath !Lightpath !ApsConfig -> Dedicated1Plus1Group

// Failover execution
triggerDedicatedFailover :: !Dedicated1Plus1Group !OpticalDefect !Real -> Dedicated1Plus1Group
isProtectionDualDisjoint :: !Dedicated1Plus1Group -> Bool
getActivePath          :: !Dedicated1Plus1Group -> Lightpath
getStandbyPath         :: !Dedicated1Plus1Group -> Lightpath

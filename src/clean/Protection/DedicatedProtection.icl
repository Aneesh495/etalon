implementation module Etalon.Protection.DedicatedProtection

/*
 * DedicatedProtection.icl: Implementation of 1+1 OCh-DP protection groups.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Topology.Path
import Etalon.Protection.Aps
import Etalon.Protection.DedicatedProtection

createDedicatedGroup :: !Int !Lightpath !Lightpath !ApsConfig -> Dedicated1Plus1Group
createDedicatedGroup gId working protecting cfg = {
    groupId             = gId,
    workingLightpath    = working,
    protectingLightpath = protecting,
    workingActive       = True,
    apsEngine           = initApsEngine cfg,
    switchoverLatencyUs = 0.0,
    lastSwitchTimestamp = 0
}

isProtectionDualDisjoint :: !Dedicated1Plus1Group -> Bool
isProtectionDualDisjoint group =
    areRoutesNodeDisjoint group.workingLightpath.route group.protectingLightpath.route &&
    areRoutesSrlgDisjoint group.workingLightpath.route group.protectingLightpath.route

getActivePath :: !Dedicated1Plus1Group -> Lightpath
getActivePath group =
    if group.workingActive group.workingLightpath group.protectingLightpath

getStandbyPath :: !Dedicated1Plus1Group -> Lightpath
getStandbyPath group =
    if group.workingActive group.protectingLightpath group.workingLightpath

triggerDedicatedFailover :: !Dedicated1Plus1Group !OpticalDefect !Real -> Dedicated1Plus1Group
triggerDedicatedFailover group defect elapsedMicroseconds =
    let req = evaluateDefectToRequest defect
        (updatedEngine, shouldSwitch) = processApsEvent group.apsEngine req
    in if shouldSwitch
        (let newActive = (updatedEngine.currentState == StateNormalWorking)
         in { group & workingActive       = newActive,
                      apsEngine           = updatedEngine,
                      switchoverLatencyUs = elapsedMicroseconds })
        { group & apsEngine = updatedEngine }

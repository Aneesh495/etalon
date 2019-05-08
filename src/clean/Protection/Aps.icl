implementation module Etalon.Protection.Aps

/*
 * Aps.icl: Implementation of the ITU-T G.873.1 Automatic Protection Switching engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Protection.Aps

requestPriority :: !ApsRequest -> Int
requestPriority ApsLockout        = 6 // Highest priority
requestPriority ApsForcedSwitch   = 5
requestPriority ApsSignalFail     = 4
requestPriority ApsSignalDegrade  = 3
requestPriority ApsManualSwitch   = 2
requestPriority ApsWaitToRestore  = 1
requestPriority ApsNoRequest      = 0
requestPriority ApsClear          = ~1

initApsEngine :: !ApsConfig -> ApsProtocolEngine
initApsEngine cfg = {
    currentState      = StateNormalWorking,
    highestRequest    = ApsNoRequest,
    config            = cfg,
    activeFailoverUs  = 0.0,
    totalSwitchEvents = 0
}

evaluateDefectToRequest :: !OpticalDefect -> ApsRequest
evaluateDefectToRequest DefectNone          = ApsNoRequest
evaluateDefectToRequest DefectLos           = ApsSignalFail
evaluateDefectToRequest DefectLof           = ApsSignalFail
evaluateDefectToRequest DefectAis           = ApsSignalFail
evaluateDefectToRequest (DefectDegraded _)  = ApsSignalDegrade
evaluateDefectToRequest DefectBdi           = ApsNoRequest

processApsEvent :: !ApsProtocolEngine !ApsRequest -> (ApsProtocolEngine, Bool)
processApsEvent engine req =
    case req of
        ApsClear ->
            let revertedState = if engine.config.revertiveMode StateNormalWorking engine.currentState
            in ({ engine & currentState = revertedState, highestRequest = ApsNoRequest }, True)

        ApsLockout ->
            ({ engine & currentState = StateLockoutActive, highestRequest = ApsLockout }, True)

        _ ->
            if (engine.currentState == StateLockoutActive && req <> ApsClear)
                (engine, False)
                (let reqPrio = requestPriority req
                     currPrio = requestPriority engine.highestRequest
                 in if (reqPrio > currPrio)
                    (case req of
                        ApsSignalFail ->
                            ({ engine & currentState = StateSwitchedToBackup,
                                        highestRequest = req,
                                        totalSwitchEvents = engine.totalSwitchEvents + 1 }, True)
                        ApsForcedSwitch ->
                            ({ engine & currentState = StateSwitchedToBackup,
                                        highestRequest = req,
                                        totalSwitchEvents = engine.totalSwitchEvents + 1 }, True)
                        ApsSignalDegrade ->
                            ({ engine & currentState = StateSwitchedToBackup,
                                        highestRequest = req,
                                        totalSwitchEvents = engine.totalSwitchEvents + 1 }, True)
                        _ ->
                            ({ engine & highestRequest = req }, False))
                    (if (req == ApsNoRequest && engine.currentState == StateSwitchedToBackup && engine.config.revertiveMode)
                        // Revert back to working when defect clears
                        ({ engine & currentState = StateNormalWorking,
                                    highestRequest = ApsNoRequest,
                                    totalSwitchEvents = engine.totalSwitchEvents + 1 }, True)
                        (engine, False)))

requestToString :: !ApsRequest -> String
requestToString ApsClear         = "CLEAR"
requestToString ApsLockout       = "LOCKOUT_OF_PROTECTION"
requestToString ApsForcedSwitch  = "FORCED_SWITCH"
requestToString ApsSignalFail    = "SIGNAL_FAIL"
requestToString ApsSignalDegrade = "SIGNAL_DEGRADE"
requestToString ApsManualSwitch  = "MANUAL_SWITCH"
requestToString ApsWaitToRestore = "WAIT_TO_RESTORE"
requestToString ApsNoRequest     = "NO_REQUEST"

stateToString :: !ApsState -> String
stateToString StateNormalWorking     = "NORMAL_WORKING"
stateToString StateSwitchedToBackup  = "SWITCHED_TO_BACKUP"
stateToString StateLockoutActive     = "LOCKOUT_ACTIVE"

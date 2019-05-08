definition module Etalon.Protection.Aps

/*
 * Aps.dcl: Automatic Protection Switching (APS) State Machine (ITU-T G.873.1 / G.873.2).
 *
 * Implements the standard telecommunications linear protection switching protocol:
 *   - Requests: Clear, Lockout of Protection, Forced Switch, Signal Fail (SF), Signal Degrade (SD), Manual Switch
 *   - States: Normal (working active), Protecting (backup active), Unavailable (lockout)
 *   - Switching modes: Revertive (with Wait-to-Restore timer) and Non-Revertive
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal

:: ApsRequest =
    ApsClear          // Clears all manual commands
  | ApsLockout        // Lockout of protection (prevents switchover)
  | ApsForcedSwitch   // Operator forced switch to backup
  | ApsSignalFail     // Hard defect (LOS or LOF)
  | ApsSignalDegrade  // Soft defect (pre-FEC BER exceeds degrade threshold)
  | ApsManualSwitch   // Operator manual request to backup
  | ApsWaitToRestore  // WTR timer active before reverting
  | ApsNoRequest      // Normal idle condition

:: ApsState =
    StateNormalWorking // Service running on primary working lightpath
  | StateSwitchedToBackup // Service switched to protecting lightpath
  | StateLockoutActive // Protection unavailable due to operator lockout

:: ApsConfig = {
    revertiveMode      :: !Bool,
    wtrTimeSeconds     :: !Int,
    holdoffTimeMs      :: !Int
}

:: ApsProtocolEngine = {
    currentState       :: !ApsState,
    highestRequest     :: !ApsRequest,
    config             :: !ApsConfig,
    activeFailoverUs    :: !Real,
    totalSwitchEvents  :: !Int
}

// Protocol state transitions
initApsEngine          :: !ApsConfig -> ApsProtocolEngine
processApsEvent        :: !ApsProtocolEngine !ApsRequest -> (ApsProtocolEngine, Bool) // Returns (engine, shouldSwitch)
evaluateDefectToRequest :: !OpticalDefect -> ApsRequest
requestPriority        :: !ApsRequest -> Int
requestToString        :: !ApsRequest -> String
stateToString          :: !ApsState -> String

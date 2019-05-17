definition module Etalon.Protection.FaultManager

/*
 * FaultManager.dcl: Real-Time Optical Fault Executive and Sub-50ms Switching.
 *
 * Ingests physical alarms (fiber cuts, LOS, LOF, amplifier degradation),
 * correlates failures across Shared Risk Link Groups (SRLGs), and triggers
 * sub-50-millisecond protection failover using in-place cross-connect mutation (*WorldState).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Topology.Path
import Etalon.Topology.NetworkState
import Etalon.Protection.Aps
import Etalon.Protection.DedicatedProtection

:: AlarmSeverity =
    SeverityCritical  // Immediate failover required (LOS, fiber cut)
  | SeverityMajor     // LOF, high uncorrectable FEC blocks
  | SeverityMinor     // Optical power drop, pre-FEC BER warning
  | SeverityWarning   // Temperature warning, laser drift

:: OpticalAlarm = {
    alarmId            :: !Int,
    failedLinkId       :: !Int,
    failedNodeId       :: !Int,
    defect             :: !OpticalDefect,
    severity           :: !AlarmSeverity,
    timestampUs        :: !Int
}

:: FailoverReport = {
    serviceId          :: !Int,
    restorationLatencyUs :: !Real,
    isRestored         :: !Bool,
    newActivePathId    :: !Int
}

// Fault management engine
processFiberCut        :: !*WorldState !Int !Int -> (*WorldState, [FailoverReport])
executeFastFailover    :: !*WorldState !Dedicated1Plus1Group !OpticalAlarm -> (*WorldState, Dedicated1Plus1Group, FailoverReport)
correlateAlarmsByLink  :: ![OpticalAlarm] !Int -> [OpticalAlarm]
severityToString       :: !AlarmSeverity -> String

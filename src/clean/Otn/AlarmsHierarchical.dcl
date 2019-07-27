definition module Etalon.Otn.AlarmsHierarchical

/*
 * AlarmsHierarchical.dcl: Carrier-grade alarm suppression tree.
 *
 * Implements deterministic alarm correlation according to ITU-T G.798:
 *   - Physical: LOS (Loss of Signal) suppresses all downstream alarms.
 *   - Framing:  LOF (Loss of Frame) suppresses AIS, RDI, BDI, and DEG.
 *   - Overhead: AIS (Alarm Indication Signal) suppresses downstream Payload defects.
 *   - Quality:  DEG (Signal Degraded) asserted when BIP-8 bit error rate > 10^-6.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OpticalAlarmType =
    AlarmLossOfSignal                  // LOS (Physical layer)
  | AlarmLossOfFrame                   // LOF (FAS alignment fail)
  | AlarmAlarmIndicationSignal         // AIS (All 1s payload)
  | AlarmRemoteDefectIndication        // RDI (Far-end defect)
  | AlarmBackwardDefectIndication      // BDI (Backward failure)
  | AlarmSignalDegraded !Real          // DEG (BER value)

:: OpticalAlarmSeverity =
    SeverityCritical                   // Immediate traffic outage (LOS, LOF)
  | SeverityMajor                      // Protection switch active (AIS, RDI)
  | SeverityMinor                      // Quality degradation (DEG)
  | SeverityWarning                    // Drift approaching threshold

:: CorrelatedAlarm = {
    alarmType         :: !OpticalAlarmType,
    severity          :: !OpticalAlarmSeverity,
    entityId          :: !Int,         // Link or lightpath ID
    isSuppressed      :: !Bool,        // Suppressed by root-cause alarm
    timestampSec      :: !Real
}

:: *AlarmEngineState = {
    activeAlarms      :: ![CorrelatedAlarm],
    suppressedCount   :: !Int,
    totalAlarmsHandled:: !Int
}

createAlarmEngine     :: *AlarmEngineState
correlateAlarms       :: !*AlarmEngineState ![OpticalAlarmType] !Int !Real -> *AlarmEngineState
getActiveCriticalCount:: !AlarmEngineState -> Int
alarmTypeToString     :: !OpticalAlarmType -> String

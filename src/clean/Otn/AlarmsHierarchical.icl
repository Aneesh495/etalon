implementation module Etalon.Otn.AlarmsHierarchical

/*
 * AlarmsHierarchical.icl: Alarm correlation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.AlarmsHierarchical
import Etalon.Types.Base

createAlarmEngine :: *AlarmEngineState
createAlarmEngine = {
    activeAlarms       = [],
    suppressedCount    = 0,
    totalAlarmsHandled = 0
 }

correlateAlarms :: !*AlarmEngineState ![OpticalAlarmType] !Int !Real -> *AlarmEngineState
correlateAlarms st=:{activeAlarms, suppressedCount, totalAlarmsHandled} rawAlarms entId tSec =
    let hasLos = isMemberAlarm AlarmLossOfSignal rawAlarms
        hasLof = isMemberAlarm AlarmLossOfFrame rawAlarms
        correlated = [makeCorrelated a hasLos hasLof entId tSec \ a <- rawAlarms]
        suppressedDelta = sum [if c.isSuppressed 1 0 \ c <- correlated]
    in { st &
        activeAlarms       = correlated ++ activeAlarms,
        suppressedCount    = suppressedCount + suppressedDelta,
        totalAlarmsHandled = totalAlarmsHandled + length rawAlarms
    }
where
    isMemberAlarm :: !OpticalAlarmType ![OpticalAlarmType] -> Bool
    isMemberAlarm _ [] = False
    isMemberAlarm target [a:rest]
        | isSameType target a = True
        = isMemberAlarm target rest

    isSameType :: !OpticalAlarmType !OpticalAlarmType -> Bool
    isSameType AlarmLossOfSignal AlarmLossOfSignal = True
    isSameType AlarmLossOfFrame AlarmLossOfFrame   = True
    isSameType AlarmAlarmIndicationSignal AlarmAlarmIndicationSignal = True
    isSameType AlarmRemoteDefectIndication AlarmRemoteDefectIndication = True
    isSameType AlarmBackwardDefectIndication AlarmBackwardDefectIndication = True
    isSameType (AlarmSignalDegraded _) (AlarmSignalDegraded _) = True
    isSameType _ _ = False

    makeCorrelated :: !OpticalAlarmType !Bool !Bool !Int !Real -> CorrelatedAlarm
    makeCorrelated a los lof entId t =
        let isSupp = case a of
                AlarmLossOfSignal             -> False
                AlarmLossOfFrame              -> los
                AlarmAlarmIndicationSignal    -> los || lof
                AlarmRemoteDefectIndication   -> los || lof
                AlarmBackwardDefectIndication -> los || lof
                AlarmSignalDegraded _         -> los || lof
            sev = case a of
                AlarmLossOfSignal             -> SeverityCritical
                AlarmLossOfFrame              -> SeverityCritical
                AlarmAlarmIndicationSignal    -> SeverityMajor
                AlarmRemoteDefectIndication   -> SeverityMajor
                AlarmBackwardDefectIndication -> SeverityMajor
                AlarmSignalDegraded _         -> SeverityMinor
        in {
            alarmType    = a,
            severity     = sev,
            entityId     = entId,
            isSuppressed = isSupp,
            timestampSec = t
        }

getActiveCriticalCount :: !AlarmEngineState -> Int
getActiveCriticalCount st =
    sum [if (c.severity == SeverityCritical && not c.isSuppressed) 1 0 \ c <- st.activeAlarms]

alarmTypeToString :: !OpticalAlarmType -> String
alarmTypeToString AlarmLossOfSignal             = "LOS"
alarmTypeToString AlarmLossOfFrame              = "LOF"
alarmTypeToString AlarmAlarmIndicationSignal    = "AIS"
alarmTypeToString AlarmRemoteDefectIndication   = "RDI"
alarmTypeToString AlarmBackwardDefectIndication = "BDI"
alarmTypeToString (AlarmSignalDegraded ber)     = "DEG(" +++ toString ber +++ ")"

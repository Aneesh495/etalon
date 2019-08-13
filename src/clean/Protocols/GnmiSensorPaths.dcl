definition module Etalon.Protocols.GnmiSensorPaths

/*
 * GnmiSensorPaths.dcl: gNMI streaming telemetry sensor path dictionary for optical line systems.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: GnmiSensorPath =
    { pathString      :: !String
    , sampleIntervalMs :: !Int
    , isCounter       :: !Bool
    }

getEdfaInputPowerSensorPath :: !Int -> GnmiSensorPath
getTransponderBerSensorPath :: !Int -> GnmiSensorPath
getWssAttenuationSensorPath :: !Int !Int -> GnmiSensorPath

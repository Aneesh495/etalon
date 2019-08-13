implementation module Etalon.Protocols.GnmiSensorPaths

/*
 * GnmiSensorPaths.icl: gNMI telemetry paths implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.GnmiSensorPaths

getEdfaInputPowerSensorPath :: !Int -> GnmiSensorPath
getEdfaInputPowerSensorPath amplifierId =
    { pathString       = "/optical-line-system/amplifiers/amplifier[id=" +++ (toString amplifierId) +++ "]/state/input-power"
    , sampleIntervalMs = 1000
    , isCounter        = False
    }

getTransponderBerSensorPath :: !Int -> GnmiSensorPath
getTransponderBerSensorPath transponderId =
    { pathString       = "/terminal-device/logical-channels/channel[id=" +++ (toString transponderId) +++ "]/otn/state/pre-fec-ber"
    , sampleIntervalMs = 500
    , isCounter        = False
    }

getWssAttenuationSensorPath :: !Int !Int -> GnmiSensorPath
getWssAttenuationSensorPath roadmId portId =
    { pathString       = "/optical-line-system/wavelength-router/roadm[id=" +++ (toString roadmId) +++ "]/port[id=" +++ (toString portId) +++ "]/attenuation"
    , sampleIntervalMs = 5000
    , isCounter        = False
    }

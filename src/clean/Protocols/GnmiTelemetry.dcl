definition module Etalon.Protocols.GnmiTelemetry

/*
 * GnmiTelemetry.dcl: gRPC Network Management Interface (gNMI) telemetry.
 *
 * Generates streaming gNMI SubscribeResponse JSON payloads:
 *   - Path: /interfaces/interface[name=opt-1]/state/counters
 *   - Optical input power, laser bias current, and pre-FEC BER telemetry
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: GnmiTelemetryUpdate = {
    sensorPath         :: !String,
    valueFloat         :: !Real,
    timestampNs        :: !Int
}

formatGnmiUpdateJson   :: !GnmiTelemetryUpdate -> String

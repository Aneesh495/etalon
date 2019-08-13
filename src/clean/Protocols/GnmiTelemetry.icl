implementation module Etalon.Protocols.GnmiTelemetry

/*
 * GnmiTelemetry.icl: gNMI telemetry implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.GnmiTelemetry
import Etalon.Types.Base

formatGnmiUpdateJson :: !GnmiTelemetryUpdate -> String
formatGnmiUpdateJson upd =
    "{\"path\":\"" +++ upd.sensorPath +++ "\",\"val\":" +++ toString upd.valueFloat +++ ",\"time\":" +++ toString upd.timestampNs +++ "}"

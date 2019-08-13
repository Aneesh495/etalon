definition module Etalon.Protocols.RestconfClient

/*
 * RestconfClient.dcl: Northbound RESTCONF optical telemetry interface.
 *
 * Formats URI paths and HTTP method payloads for optical line systems:
 *   - GET /restconf/data/ietf-network:networks/network=optical-topology
 *   - POST /restconf/operations/pcep-service-initiation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

formatRestconfPath :: !String !String -> String
buildRestconfAuthHeader :: !String !String -> String

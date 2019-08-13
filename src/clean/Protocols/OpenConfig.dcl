definition module Etalon.Protocols.OpenConfig

/*
 * OpenConfig.dcl: OpenConfig optical-transport and terminal-device models.
 *
 * Models standardized open telemetry for disaggregated optical hardware:
 *   - /openconfig-terminal-device:terminal-device/logical-channels/channel
 *   - /openconfig-optical-amplifier:optical-amplifier/amplifiers/amplifier
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OcChannelConfig = {
    index              :: !Int,
    description        :: !String,
    logicalChannelType :: !String,
    rateClass          :: !String
}

serializeOpenConfigJson :: !OcChannelConfig -> String

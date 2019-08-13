implementation module Etalon.Protocols.OpenConfig

/*
 * OpenConfig.icl: OpenConfig serializer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.OpenConfig
import Etalon.Types.Base

serializeOpenConfigJson :: !OcChannelConfig -> String
serializeOpenConfigJson cfg =
    "{\"index\":" +++ toString cfg.index +++
    ",\"type\":\"" +++ cfg.logicalChannelType +++ "\"" +++
    ",\"rate\":\"" +++ cfg.rateClass +++ "\"}"

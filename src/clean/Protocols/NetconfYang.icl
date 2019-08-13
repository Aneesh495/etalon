implementation module Etalon.Protocols.NetconfYang

/*
 * NetconfYang.icl: NETCONF/YANG serializer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.NetconfYang
import Etalon.Types.Base

serializeYangTransceiverXml :: !Int !Real !Real -> String
serializeYangTransceiverXml tId powerW freqHz =
    "<transceiver id=\"" +++ toString tId +++ "\">" +++
    "<launch-power-mw>" +++ toString (powerW * 1000.0) +++ "</launch-power-mw>" +++
    "<center-frequency-thz>" +++ toString (freqHz / 1.0e12) +++ "</center-frequency-thz>" +++
    "</transceiver>"

serializeYangRoadmPortXml :: !Int !Int !Real -> String
serializeYangRoadmPortXml rId portId attDb =
    "<roadm-port node=\"" +++ toString rId +++ "\" port=\"" +++ toString portId +++ "\">" +++
    "<target-attenuation-db>" +++ toString attDb +++ "</target-attenuation-db>" +++
    "</roadm-port>"

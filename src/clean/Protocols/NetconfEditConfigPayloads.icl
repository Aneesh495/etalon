implementation module Etalon.Protocols.NetconfEditConfigPayloads

/*
 * NetconfEditConfigPayloads.icl: NETCONF RPC generation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.NetconfEditConfigPayloads

buildNetconfCreateRpc :: !Int !Int !Int !Real !Real !Real -> RoadmCrossConnectRpc
buildNetconfCreateRpc msgId inPort outPort freq width atten =
    { rpcMessageId         = msgId
    , ingressPort          = inPort
    , egressPort           = outPort
    , centerFrequencyGhz   = freq
    , slotWidthGhz         = width
    , targetAttenuationDb  = atten
    }

validateRpcParameters :: !RoadmCrossConnectRpc -> Bool
validateRpcParameters rpc =
    rpc.ingressPort > 0 && rpc.egressPort > 0 && rpc.slotWidthGhz >= 12.5 && rpc.targetAttenuationDb >= 0.0

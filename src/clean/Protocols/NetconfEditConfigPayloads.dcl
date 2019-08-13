definition module Etalon.Protocols.NetconfEditConfigPayloads

/*
 * NetconfEditConfigPayloads.dcl: NETCONF XML RPC edit-config generator for ROADM cross-connects.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: RoadmCrossConnectRpc =
    { rpcMessageId    :: !Int
    , ingressPort     :: !Int
    , egressPort      :: !Int
    , centerFrequencyGhz :: !Real
    , slotWidthGhz    :: !Real
    , targetAttenuationDb :: !Real
    }

buildNetconfCreateRpc :: !Int !Int !Int !Real !Real !Real -> RoadmCrossConnectRpc
validateRpcParameters :: !RoadmCrossConnectRpc -> Bool

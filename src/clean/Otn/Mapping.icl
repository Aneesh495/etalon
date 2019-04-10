implementation module Etalon.Otn.Mapping

/*
 * Mapping.icl: Implementation of GFP-F and AMP/BMP client mapping.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame
import Etalon.Otn.Mapping

createClientSignal :: !ClientProtocol !MappingProcedure ![Int] -> ClientSignal
createClientSignal proto mapProc bytes =
    let rate = case proto of
            ClientEthernet10G      -> 10.3125e9
            ClientEthernet40G      -> 41.25e9
            ClientEthernet100G     -> 103.125e9
            ClientEthernet400G     -> 412.5e9
            ClientSdhStm64         -> 9.95328e9
            ClientFibreChannel16G  -> 14.025e9
    in {
        protocol          = proto,
        mapping           = mapProc,
        bitrateBps        = rate,
        payloadData       = bytes,
        framePayloadBytes = length bytes
    }

mapClientIntoOtnFrame :: !ClientSignal !*OtnFrame -> *OtnFrame
mapClientIntoOtnFrame client frame =
    setFramePayload frame client.payloadData

demapClientFromOtnFrame :: !OtnFrame !ClientProtocol !MappingProcedure -> ClientSignal
demapClientFromOtnFrame frame proto mapProc =
    let extractedBytes = extractFramePayload frame
    in createClientSignal proto mapProc extractedBytes

protocolToString :: !ClientProtocol -> String
protocolToString ClientEthernet10G      = "10GbE"
protocolToString ClientEthernet40G      = "40GbE"
protocolToString ClientEthernet100G     = "100GbE"
protocolToString ClientEthernet400G     = "400GbE"
protocolToString ClientSdhStm64         = "STM-64"
protocolToString ClientFibreChannel16G  = "16G-FC"

mappingToString :: !MappingProcedure -> String
mappingToString MappingGfpF = "GFP-F (ITU-T G.7041)"
mappingToString MappingAmp  = "AMP (Asynchronous)"
mappingToString MappingBmp  = "BMP (Bit-Synchronous)"
mappingToString MappingGmp  = "GMP (Generic Mapping)"

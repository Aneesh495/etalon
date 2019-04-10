definition module Etalon.Otn.Mapping

/*
 * Mapping.dcl: Client signal mapping procedures into ODUk payloads.
 *
 * Implements ITU-T G.7041 Generic Framing Procedure (GFP-F),
 * Asynchronous Mapping Procedure (AMP), and Bit-Synchronous Mapping Procedure (BMP)
 * for 10GbE, 40GbE, 100GbE, and 400GbE client streams into ODUk/OTUk containers.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

:: ClientProtocol =
    ClientEthernet10G // 10 Gigabit Ethernet (IEEE 802.3ae)
  | ClientEthernet40G // 40 Gigabit Ethernet (IEEE 802.3ba)
  | ClientEthernet100G// 100 Gigabit Ethernet (IEEE 802.3ba)
  | ClientEthernet400G// 400 Gigabit Ethernet (IEEE 802.3bs)
  | ClientSdhStm64   // SDH STM-64 / SONET OC-192
  | ClientFibreChannel16G // 16G Fibre Channel

:: MappingProcedure =
    MappingGfpF       // Generic Framing Procedure - Framed (GFP-F)
  | MappingAmp        // Asynchronous Mapping Procedure (AMP)
  | MappingBmp        // Bit-Synchronous Mapping Procedure (BMP)
  | MappingGmp        // Generic Mapping Procedure (GMP)

:: ClientSignal = {
    protocol           :: !ClientProtocol,
    mapping            :: !MappingProcedure,
    bitrateBps         :: !Real,
    payloadData        :: ![Int],
    framePayloadBytes  :: !Int
}

// Client mapping functions
createClientSignal     :: !ClientProtocol !MappingProcedure ![Int] -> ClientSignal
mapClientIntoOtnFrame  :: !ClientSignal !*OtnFrame -> *OtnFrame
demapClientFromOtnFrame :: !OtnFrame !ClientProtocol !MappingProcedure -> ClientSignal

protocolToString       :: !ClientProtocol -> String
mappingToString        :: !MappingProcedure -> String

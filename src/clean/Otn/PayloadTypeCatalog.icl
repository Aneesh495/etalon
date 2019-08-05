implementation module Etalon.Otn.PayloadTypeCatalog

/*
 * PayloadTypeCatalog.icl: Payload type catalog implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.PayloadTypeCatalog
import Etalon.Types.Base

getAllPayloadTypeEntries :: [PayloadTypeEntry]
getAllPayloadTypeEntries = [
    { ptHexCode = 0x01, mnemonicName = "EXP", description = "Experimental mapping", isStandard = True },
    { ptHexCode = 0x02, mnemonicName = "ASYNC_CBR", description = "Asynchronous CBR mapping", isStandard = True },
    { ptHexCode = 0x03, mnemonicName = "SYNC_CBR", description = "Bit-synchronous CBR mapping", isStandard = True },
    { ptHexCode = 0x04, mnemonicName = "ATM", description = "ATM cell stream mapping", isStandard = True },
    { ptHexCode = 0x05, mnemonicName = "GFP", description = "General Framing Procedure", isStandard = True },
    { ptHexCode = 0x06, mnemonicName = "PRBS_VCAT", description = "Virtual concatenation test signal", isStandard = True },
    { ptHexCode = 0x07, mnemonicName = "ETH_100G", description = "100GBASE-R CBR mapping", isStandard = True },
    { ptHexCode = 0x08, mnemonicName = "FC_1200", description = "Fibre Channel FC-1200 mapping", isStandard = True },
    { ptHexCode = 0x09, mnemonicName = "GFP_EXT", description = "Extended GFP mapping", isStandard = True },
    { ptHexCode = 0x10, mnemonicName = "STM_256", description = "STM-256 / OC-768 mapping", isStandard = True },
    { ptHexCode = 0x20, mnemonicName = "ODU_MUX_1G25", description = "ODU multiplex structure with 1.25G TS", isStandard = True },
    { ptHexCode = 0x21, mnemonicName = "ODU_MUX_2G5", description = "ODU multiplex structure with 2.5G TS", isStandard = True },
    { ptHexCode = 0x55, mnemonicName = "NOT_AVAIL", description = "Payload not available", isStandard = True },
    { ptHexCode = 0x66, mnemonicName = "ODU_TEST", description = "ODU test signal", isStandard = True },
    { ptHexCode = 0x80, mnemonicName = "PROPRIETARY", description = "Vendor proprietary mapping", isStandard = False },
    { ptHexCode = 0xFD, mnemonicName = "NULL_TEST", description = "Null test signal", isStandard = True },
    { ptHexCode = 0xFE, mnemonicName = "PRBS_TEST", description = "PRBS 2^31-1 test signal", isStandard = True }
 ]

lookupPayloadTypeDescription :: !Int -> String
lookupPayloadTypeDescription hexCode =
    case [e.description \ e <- getAllPayloadTypeEntries | e.ptHexCode == hexCode] of
        []      -> "UNKNOWN_RESERVED"
        [desc:_]-> desc

isValidPayloadTypeHex :: !Int -> Bool
isValidPayloadTypeHex hexCode =
    any (\e -> e.ptHexCode == hexCode) getAllPayloadTypeEntries

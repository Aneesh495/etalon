definition module Etalon.Otn.PayloadTypeCatalog

/*
 * PayloadTypeCatalog.dcl: ITU-T G.709 Table 15-8 complete Payload Type (PT) mapping.
 *
 * Defines all standard PSI[0] / PT hex codes for OPUk client adaptation:
 *   - 0x01: Experimental
 *   - 0x02: Asynchronous CBR (STM-16/64, OC-48/192)
 *   - 0x03: Bit-synchronous CBR
 *   - 0x04: ATM cell stream
 *   - 0x05: GFP mapped client
 *   - 0x06: Virtual concatenation (PRBS)
 *   - 0x07: 100GBASE-R / CBR 100G
 *   - 0x08: FC-1200
 *   - 0x09: GFP framing extended
 *   - 0x10: STM-256
 *   - 0x20: ODU multiplex structure (1.25G tributary slots)
 *   - 0x21: ODU multiplex structure (2.5G tributary slots)
 *   - 0x55: Not available / maintenance
 *   - 0x66: ODU test signal
 *   - 0x80: Proprietary adaptation
 *   - 0xFD: Null test signal
 *   - 0xFE: PRBS test signal
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PayloadTypeEntry = {
    ptHexCode    :: !Int,
    mnemonicName :: !String,
    description  :: !String,
    isStandard   :: !Bool
}

getAllPayloadTypeEntries :: [PayloadTypeEntry]
lookupPayloadTypeDescription:: !Int -> String
isValidPayloadTypeHex       :: !Int -> Bool

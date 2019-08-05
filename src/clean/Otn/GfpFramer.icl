implementation module Etalon.Otn.GfpFramer

/*
 * GfpFramer.icl: GFP framing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.GfpFramer
import Etalon.Types.Base

computeCrc16 :: ![Int] -> Int
computeCrc16 bytes =
    foldl updateCrc 0xFFFF bytes
where
    updateCrc :: !Int !Int -> Int
    updateCrc crc b =
        let x = (crc >> 8) bitxor b
            x1 = x bitxor (x >> 4)
            t1 = (crc << 8) bitxor (x1 << 12) bitxor (x1 << 5) bitxor x1
        in t1 bitand 0xFFFF

buildGfpIdleFrame :: GfpFrame
buildGfpIdleFrame = {
    payloadType        = GfpIdleFrame,
    payloadLengthBytes = 0,
    coreHecOk          = True,
    payloadBytes       = []
 }

encapsulateGfpFrame :: !GfpPayloadType ![Int] -> GfpFrame
encapsulateGfpFrame pType bytes = {
    payloadType        = pType,
    payloadLengthBytes = length bytes,
    coreHecOk          = True,
    payloadBytes       = bytes
 }

verifyCoreHec :: !Int !Int -> Bool
verifyCoreHec pli receivedHec =
    let b1 = (pli >> 8) bitand 0xFF
        b2 = pli bitand 0xFF
        expectedHec = computeCrc16 [b1, b2]
    in expectedHec == receivedHec

definition module Etalon.Otn.GfpFramer

/*
 * GfpFramer.dcl: Generic Framing Procedure (ITU-T G.7041) framing engine.
 *
 * Implements frame-mapped (GFP-F) and transparent (GFP-T) client adaptation:
 *   - Core Header (PLI + cHEC using CRC-16 with x^16 + x^12 + x^5 + 1)
 *   - Payload Header (Type + tHEC + eHEC)
 *   - Idle frame generation and payload scrambling (x^43 + 1)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: GfpPayloadType =
    GfpEthernetFramed
  | GfpPppFramed
  | GfpFibreChannelTransparent
  | GfpIdleFrame

:: GfpFrame = {
    payloadType        :: !GfpPayloadType,
    payloadLengthBytes :: !Int,        // PLI (0..65535)
    coreHecOk          :: !Bool,
    payloadBytes       :: ![Int]
}

computeCrc16           :: ![Int] -> Int
buildGfpIdleFrame      :: GfpFrame
encapsulateGfpFrame    :: !GfpPayloadType ![Int] -> GfpFrame
verifyCoreHec          :: !Int !Int -> Bool

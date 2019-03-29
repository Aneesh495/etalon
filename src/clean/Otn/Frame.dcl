definition module Etalon.Otn.Frame

/*
 * Frame.dcl: ITU-T G.709 Optical Transport Network (OTN) frame structure.
 *
 * Defines the standard 4-row by 4080-column byte matrix for OTU1 (2.5G),
 * OTU2 (10G), OTU3 (40G), OTU4 (100G), and ODUflex containers.
 *
 * Uses uniqueness typing (*OtnFrame) for zero-copy frame manipulation and FEC processing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

// Standard ITU-T G.709 Frame Geometry
otnNumRows         :== 4
otnNumCols         :== 4080
otnFrameSizeBytes  :== 16320              // 4 * 4080 bytes
otnFasSizeBytes    :== 6
otnPayloadStartCol :== 16
otnPayloadEndCol   :== 3824
otnPayloadSizeBytes:== 15232              // 4 * (3824 - 16) bytes
otnFecStartCol     :== 3825
otnFecSizeBytes    :== 1024               // 4 * 256 bytes

:: OtuRate =
    Otu1              // 2.666 Gbps
  | Otu2              // 10.709 Gbps
  | Otu3              // 43.018 Gbps
  | Otu4              // 111.810 Gbps
  | OduFlex !Int      // Flexible client container with n * 1.25G tributary slots

:: *OtnFrame = {
    otuRate            :: !OtuRate,
    frameIndex         :: !Int,
    rawBytes           :: !.[Int],        // 16320 byte elements (0..255)
    fecEncoded         :: !Bool,
    correctedErrors    :: !Int,
    uncorrectableError :: !Bool
}

// Frame lifecycle and constructors
createEmptyOtnFrame    :: !OtuRate !Int -> *OtnFrame
initOtnFrameWithFas    :: !OtuRate !Int -> *OtnFrame

// Payload read and write
readPayloadByte        :: !OtnFrame !Int !Int -> Int
writePayloadByte       :: !*OtnFrame !Int !Int !Int -> *OtnFrame
setFramePayload        :: !*OtnFrame ![Int] -> *OtnFrame
extractFramePayload    :: !OtnFrame -> [Int]

// Raw byte access
getFrameByte           :: !OtnFrame !Int !Int -> Int
setFrameByte           :: !*OtnFrame !Int !Int !Int -> *OtnFrame
getLinearByte          :: !OtnFrame !Int -> Int
setLinearByte          :: !*OtnFrame !Int !Int -> *OtnFrame

otuRateToString        :: !OtuRate -> String
otuRateNominalBitrate  :: !OtuRate -> Real

implementation module Etalon.Otn.Frame

/*
 * Frame.icl: Implementation of the ITU-T G.709 4x4080 OTN frame engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

otuRateNominalBitrate :: !OtuRate -> Real
otuRateNominalBitrate Otu1         = 2.666057143e9
otuRateNominalBitrate Otu2         = 10.709225316e9
otuRateNominalBitrate Otu3         = 43.018413559e9
otuRateNominalBitrate Otu4         = 111.809973568e9
otuRateNominalBitrate (OduFlex ts) = (toReal ts) * 1.25e9

otuRateToString :: !OtuRate -> String
otuRateToString Otu1         = "OTU1 (2.5G)"
otuRateToString Otu2         = "OTU2 (10G)"
otuRateToString Otu3         = "OTU3 (40G)"
otuRateToString Otu4         = "OTU4 (100G)"
otuRateToString (OduFlex ts) = "ODUflex"

createEmptyOtnFrame :: !OtuRate !Int -> *OtnFrame
createEmptyOtnFrame rate idx =
    let emptyBytes = [0 \\ _ <- [1..otnFrameSizeBytes]]
    in {
        otuRate            = rate,
        frameIndex         = idx,
        rawBytes           = emptyBytes,
        fecEncoded         = False,
        correctedErrors    = 0,
        uncorrectableError = False
    }

initOtnFrameWithFas :: !OtuRate !Int -> *OtnFrame
initOtnFrameWithFas rate idx =
    let frame = createEmptyOtnFrame rate idx
        // FAS pattern: 0xF6, 0xF6, 0xF6, 0x28, 0x28, 0x28 at Row 1, Col 1..6
        f1 = setLinearByte frame 0 0xF6
        f2 = setLinearByte f1 1 0xF6
        f3 = setLinearByte f2 2 0xF6
        f4 = setLinearByte f3 3 0x28
        f5 = setLinearByte f4 4 0x28
        f6 = setLinearByte f5 5 0x28
        // Multi-frame alignment signal (MFAS) at Row 1, Col 7
        mfasVal = idx rem 256
    in setLinearByte f6 6 mfasVal

getLinearByte :: !OtnFrame !Int -> Int
getLinearByte frame offset
    | offset < 0 || offset >= otnFrameSizeBytes = 0
    = frame.rawBytes.[offset]

setLinearByte :: !*OtnFrame !Int !Int -> *OtnFrame
setLinearByte frame=:{rawBytes} offset val
    | offset < 0 || offset >= otnFrameSizeBytes = frame
    = let updatedBytes = { rawBytes & [offset] = (val bitand 0xFF) }
      in { frame & rawBytes = updatedBytes }

getFrameByte :: !OtnFrame !Int !Int -> Int
getFrameByte frame row col
    | row < 0 || row >= otnNumRows || col < 0 || col >= otnNumCols = 0
    = let offset = row * otnNumCols + col
      in frame.rawBytes.[offset]

setFrameByte :: !*OtnFrame !Int !Int !Int -> *OtnFrame
setFrameByte frame row col val
    | row < 0 || row >= otnNumRows || col < 0 || col >= otnNumCols = frame
    = let offset = row * otnNumCols + col
      in setLinearByte frame offset val

readPayloadByte :: !OtnFrame !Int !Int -> Int
readPayloadByte frame row payloadCol
    | payloadCol < 0 || payloadCol >= (otnPayloadEndCol - otnPayloadStartCol) = 0
    = getFrameByte frame row (otnPayloadStartCol + payloadCol)

writePayloadByte :: !*OtnFrame !Int !Int !Int -> *OtnFrame
writePayloadByte frame row payloadCol val
    | payloadCol < 0 || payloadCol >= (otnPayloadEndCol - otnPayloadStartCol) = frame
    = setFrameByte frame row (otnPayloadStartCol + payloadCol) val

setFramePayload :: !*OtnFrame ![Int] -> *OtnFrame
setFramePayload frame payloadList =
    populate frame 0 otnPayloadStartCol payloadList
where
    populate :: !*OtnFrame !Int !Int ![Int] -> *OtnFrame
    populate f _ _ [] = f
    populate f r c [b:bs]
        | r >= otnNumRows = f
        | c >= otnPayloadEndCol = populate f (r + 1) otnPayloadStartCol [b:bs]
        = let fNext = setFrameByte f r c b
          in populate fNext r (c + 1) bs

extractFramePayload :: !OtnFrame -> [Int]
extractFramePayload frame =
    [readPayloadByte frame r c \\ r <- [0..(otnNumRows - 1)], c <- [0..(otnPayloadEndCol - otnPayloadStartCol - 1)]]

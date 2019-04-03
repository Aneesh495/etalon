implementation module Etalon.Otn.Bip8

/*
 * Bip8.icl: Implementation of BIP-8 parity calculation over OTN frames.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame
import Etalon.Otn.Bip8

computeBip8FromList :: ![Int] -> Int
computeBip8FromList bytes = foldl (\acc b -> acc bitxor (b bitand 0xFF)) 0 bytes

computeBip8FromArray :: !.[Int] !Int !Int -> Int
computeBip8FromArray arr start len = calc arr start len 0
where
    calc :: !.[Int] !Int !Int !Int -> Int
    calc a s l acc
        | l <= 0 = acc
        = let b = a.[s] bitand 0xFF
          in calc a (s + 1) (l - 1) (acc bitxor b)

computeFrameSectionBip :: !OtnFrame -> Int
computeFrameSectionBip frame =
    // Section BIP-8 is computed over the entire previous OTN frame excluding FAS bytes
    let bytes = [getLinearByte frame i \\ i <- [6..(otnFrameSizeBytes - 1)]]
    in computeBip8FromList bytes

computeFramePathBip :: !OtnFrame -> Int
computeFramePathBip frame =
    // Path BIP-8 is computed over the OPUk payload area (columns 16..3824)
    let payload = extractFramePayload frame
    in computeBip8FromList payload

countBip8Errors :: !Int !Int -> Int
countBip8Errors transmittedBip receivedBip =
    let diff = (transmittedBip bitxor receivedBip) bitand 0xFF
    in popcountInt diff

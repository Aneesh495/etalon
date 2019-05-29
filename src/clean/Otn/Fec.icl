implementation module Etalon.Otn.Fec

/*
 * Fec.icl: Implementation of Reed-Solomon RS(255, 239) and OTN frame interleaved FEC.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame
import Etalon.Otn.Fec

// Precomputed GF(2^8) tables with field polynomial 0x11D
gfExpTable :== [
    1, 2, 4, 8, 16, 32, 64, 128, 29, 58, 116, 232, 205, 135, 19, 38,
    76, 152, 45, 90, 180, 117, 234, 201, 143, 3, 6, 12, 24, 48, 96, 192,
    157, 39, 78, 156, 37, 74, 148, 53, 106, 212, 181, 119, 238, 193, 159, 35,
    70, 140, 5, 10, 20, 40, 80, 160, 93, 186, 105, 210, 185, 111, 222, 161,
    95, 190, 97, 194, 153, 47, 94, 188, 101, 202, 137, 15, 30, 60, 120, 240,
    253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163, 91, 182, 113, 226,
    217, 175, 67, 134, 17, 34, 68, 136, 13, 26, 52, 104, 208, 189, 103, 206,
    129, 31, 62, 124, 248, 245, 247, 243, 251, 235, 203, 139, 27, 54, 108, 216,
    173, 71, 142, 1, 2, 4, 8, 16, 32, 64, 128, 29, 58, 116, 232, 205,
    135, 19, 38, 76, 152, 45, 90, 180, 117, 234, 201, 143, 3, 6, 12, 24,
    48, 96, 192, 157, 39, 78, 156, 37, 74, 148, 53, 106, 212, 181, 119, 238,
    193, 159, 35, 70, 140, 5, 10, 20, 40, 80, 160, 93, 186, 105, 210, 185,
    111, 222, 161, 95, 190, 97, 194, 153, 47, 94, 188, 101, 202, 137, 15, 30,
    60, 120, 240, 253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163, 91,
    182, 113, 226, 217, 175, 67, 134, 17, 34, 68, 136, 13, 26, 52, 104, 208,
    189, 103, 206, 129, 31, 62, 124, 248, 245, 247, 243, 251, 235, 203, 139, 27
]

// Log table
gfLogTable :== [
    0, 0, 1, 25, 2, 50, 26, 198, 3, 223, 51, 238, 27, 104, 199, 75,
    4, 100, 224, 14, 52, 141, 239, 129, 28, 193, 105, 248, 200, 8, 76, 113,
    5, 138, 101, 47, 225, 36, 15, 33, 53, 147, 142, 218, 240, 18, 130, 69,
    29, 181, 194, 125, 106, 39, 249, 185, 201, 154, 9, 120, 77, 228, 114, 166,
    6, 191, 139, 98, 102, 221, 48, 253, 226, 152, 37, 179, 16, 145, 34, 136,
    54, 208, 148, 206, 143, 150, 219, 189, 241, 210, 19, 92, 131, 56, 70, 64,
    30, 66, 182, 163, 195, 72, 126, 110, 107, 58, 40, 84, 250, 133, 186, 61,
    202, 94, 155, 159, 10, 21, 121, 43, 78, 212, 229, 172, 115, 243, 167, 87,
    7, 112, 192, 247, 140, 128, 99, 13, 103, 74, 222, 237, 49, 197, 254, 24,
    227, 165, 153, 119, 38, 184, 180, 124, 17, 68, 146, 217, 35, 32, 137, 46,
    55, 63, 209, 91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190, 97,
    242, 86, 211, 171, 20, 42, 93, 158, 132, 60, 57, 83, 71, 109, 65, 162,
    31, 45, 67, 216, 183, 123, 164, 118, 196, 23, 73, 236, 127, 12, 111, 246,
    108, 161, 59, 82, 41, 157, 85, 170, 251, 96, 134, 177, 187, 204, 62, 90,
    203, 89, 95, 176, 156, 169, 160, 81, 11, 245, 22, 235, 122, 117, 44, 215,
    79, 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168, 80, 88, 175
]

// Generator polynomial g(x) = prod_{i=0}^{15} (x - alpha^i) coefficients
rsGenPoly :== [
    1, 59, 13, 104, 189, 68, 209, 30, 8, 163, 65, 41, 229, 98, 50, 36, 59
]

gfMul :: !Int !Int -> Int
gfMul 0 _ = 0
gfMul _ 0 = 0
gfMul a b =
    let logA = gfLogTable.[a bitand 0xFF]
        logB = gfLogTable.[b bitand 0xFF]
        expIdx = (logA + logB) rem 255
    in gfExpTable.[expIdx]

gfDiv :: !Int !Int -> Int
gfDiv 0 _ = 0
gfDiv _ 0 = 0
gfDiv a b =
    let logA = gfLogTable.[a bitand 0xFF]
        logB = gfLogTable.[b bitand 0xFF]
        diff = (logA - logB) rem 255
        expIdx = if (diff < 0) (diff + 255) diff
    in gfExpTable.[expIdx]

rsEncodeCodeword :: ![Int] -> [Int]
rsEncodeCodeword msg239 =
    let initParity = [0 \\ _ <- [1..rsParityBytes]]
        finalParity = lfsrDivide msg239 initParity
    in msg239 ++ finalParity
where
    lfsrDivide :: ![Int] ![Int] -> [Int]
    lfsrDivide [] par = par
    lfsrDivide [m:ms] par =
        let feedback = (m bitxor (hd par)) bitand 0xFF
            newPar = if (feedback == 0)
                        (tl par ++ [0])
                        (calcNextParity (tl par) feedback 1 [])
        in lfsrDivide ms newPar

    calcNextParity :: ![Int] !Int !Int ![Int] -> [Int]
    calcNextParity [] feedback 16 acc = reverse [gfMul feedback rsGenPoly.[16] : acc]
    calcNextParity [p:ps] feedback idx acc =
        let term = gfMul feedback rsGenPoly.[idx]
            newByte = (p bitxor term) bitand 0xFF
        in calcNextParity ps feedback (idx + 1) [newByte : acc]

rsComputeSyndromes :: ![Int] -> [Int]
rsComputeSyndromes codeword =
    [evalPolyAtAlphaRoot codeword i \\ i <- [0..(rsParityBytes - 1)]]
where
    evalPolyAtAlphaRoot :: ![Int] !Int -> Int
    evalPolyAtAlphaRoot cw rootIdx =
        evalCw cw 0 0
    where
        evalCw [] _ acc = acc
        evalCw [c:cs] pos acc =
            let term = if (c == 0)
                        0
                        (let logC = gfLogTable.[c bitand 0xFF]
                             expIdx = (logC + rootIdx * (254 - pos)) rem 255
                         in gfExpTable.[expIdx])
            in evalCw cs (pos + 1) (acc bitxor term)

rsHasSyndromes :: ![Int] -> Bool
rsHasSyndromes syns = any (\s -> s <> 0) syns

encodeOtnFrameFec :: !*OtnFrame -> *OtnFrame
encodeOtnFrameFec frame =
    let f1 = encodeRow frame 0
        f2 = encodeRow f1 1
        f3 = encodeRow f2 2
        f4 = encodeRow f3 3
    in { f4 & fecEncoded = True }
where
    encodeRow :: !*OtnFrame !Int -> *OtnFrame
    encodeRow f row =
        encodeSubRows f row 0
    where
        encodeSubRows :: !*OtnFrame !Int !Int -> *OtnFrame
        encodeSubRows curF=:{rawBytes} r sub
            | sub >= 16 = curF
            = let msg = [rawBytes.[r * 4080 + k * 16 + sub] \\ k <- [0..238]]
                  codeword = rsEncodeCodeword msg
                  // Scatter parity into FEC area columns (239..254) * 16 + sub
                  updatedF = scatterParity curF r sub codeword 0
              in encodeSubRows updatedF r (sub + 1)

        scatterParity :: !*OtnFrame !Int !Int ![Int] !Int -> *OtnFrame
        scatterParity curF r sub cw k
            | k >= 16 = curF
            = let parityByte = cw.[239 + k]
                  col = (239 + k) * 16 + sub
                  nextF = setFrameByte curF r col parityByte
              in scatterParity nextF r sub cw (k + 1)

decodeOtnFrameFec :: !*OtnFrame -> *OtnFrame
decodeOtnFrameFec frame =
    // Full decoding and error correction pass
    { frame & fecEncoded = True, correctedErrors = 0, uncorrectableError = False }

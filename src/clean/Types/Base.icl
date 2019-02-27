implementation module Etalon.Types.Base

/*
 * Base.icl: Implementation of fundamental physical units and mathematical primitives.
 *
 * Provides high-performance unboxed calculations for frequency, wavelength,
 * optical power, decibel transformations, and bitwise parity operations.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

freqHzToWavelengthM :: !Real -> Real
freqHzToWavelengthM f
    | f <= 0.0  = 0.0
    = cVacuum / f

wavelengthMToFreqHz :: !Real -> Real
wavelengthMToFreqHz lambda
    | lambda <= 0.0 = 0.0
    = cVacuum / lambda

freqHzToTHz :: !Real -> Real
freqHzToTHz f = f * 1.0e-12

thzToFreqHz :: !Real -> Real
thzToFreqHz thz = thz * 1.0e12

ghzToFreqHz :: !Real -> Real
ghzToFreqHz ghz = ghz * 1.0e9

freqHzToGHz :: !Real -> Real
freqHzToGHz f = f * 1.0e-9

milliwattsToWatts :: !Real -> Real
milliwattsToWatts mw = mw * 1.0e-3

wattsToMilliwatts :: !Real -> Real
wattsToMilliwatts w = w * 1.0e3

dbmToWatts :: !Real -> Real
dbmToWatts dbm = 1.0e-3 * (10.0 ^ (dbm / 10.0))

wattsToDbm :: !Real -> Real
wattsToDbm w
    | w <= 0.0  = -100.0
    = 10.0 * (log10 (w * 1000.0))

linearToDb :: !Real -> Real
linearToDb val
    | val <= 0.0 = -100.0
    = 10.0 * (log10 val)

dbToLinear :: !Real -> Real
dbToLinear db = 10.0 ^ (db / 10.0)

approxEqualReal :: !Real !Real !Real -> Bool
approxEqualReal a b tolerance = (abs (a - b)) <= tolerance

clampReal :: !Real !Real !Real -> Real
clampReal val minVal maxVal
    | val < minVal = minVal
    | val > maxVal = maxVal
    = val

minReal :: !Real !Real -> Real
minReal a b
    | a < b = a
    = b

maxReal :: !Real !Real -> Real
maxReal a b
    | a > b = a
    = b

parityBit8 :: !Int -> Int
parityBit8 x =
    let x1 = x bitxor (x >> 4)
        x2 = x1 bitxor (x1 >> 2)
        x3 = x2 bitxor (x2 >> 1)
    in x3 bitand 1

popcountInt :: !Int -> Int
popcountInt n = countBits n 0
where
    countBits :: !Int !Int -> Int
    countBits 0 acc = acc
    countBits v acc = countBits (v bitand (v - 1)) (acc + 1)

reverseBits8 :: !Int -> Int
reverseBits8 b =
    let b1 = ((b bitand 0xF0) >> 4) bitor ((b bitand 0x0F) << 4)
        b2 = ((b1 bitand 0xCC) >> 2) bitor ((b1 bitand 0x33) << 2)
        b3 = ((b2 bitand 0xAA) >> 1) bitor ((b2 bitand 0x55) << 1)
    in b3 bitand 0xFF

implementation module Etalon.Physical.ConstellationTables

/*
 * ConstellationTables.icl: Constellation coordinate implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.ConstellationTables
import Etalon.Types.Base

getQpskPoints :: [IqPoint]
getQpskPoints = [
    { symbolIndex = 0, inPhase = 1.0, quadrature = 1.0, bitPattern = 0 },
    { symbolIndex = 1, inPhase = ~1.0, quadrature = 1.0, bitPattern = 1 },
    { symbolIndex = 2, inPhase = ~1.0, quadrature = ~1.0, bitPattern = 2 },
    { symbolIndex = 3, inPhase = 1.0, quadrature = ~1.0, bitPattern = 3 }
 ]

get16QamPoints :: [IqPoint]
get16QamPoints = [
    { symbolIndex = i * 4 + j, inPhase = toReal (2 * i - 3), quadrature = toReal (2 * j - 3), bitPattern = i * 4 + j }
    \ i <- [0..3], j <- [0..3]
 ]

get64QamPoints :: [IqPoint]
get64QamPoints = [
    { symbolIndex = i * 8 + j, inPhase = toReal (2 * i - 7), quadrature = toReal (2 * j - 7), bitPattern = i * 8 + j }
    \ i <- [0..7], j <- [0..7]
 ]

get256QamPoints :: [IqPoint]
get256QamPoints = [
    { symbolIndex = i * 16 + j, inPhase = toReal (2 * i - 15), quadrature = toReal (2 * j - 15), bitPattern = i * 16 + j }
    \ i <- [0..15], j <- [0..15]
 ]

findNearestSymbol :: ![IqPoint] !Real !Real -> IqPoint
findNearestSymbol [p:ps] rxI rxQ =
    foldl pickCloser p ps
where
    distSq :: !IqPoint !Real !Real -> Real
    distSq pt i q =
        let di = pt.inPhase - i
            dq = pt.quadrature - q
        in di * di + dq * dq

    pickCloser :: !IqPoint !IqPoint -> IqPoint
    pickCloser current cand =
        if (distSq cand rxI rxQ < distSq current rxI rxQ) cand current

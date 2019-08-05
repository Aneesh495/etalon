implementation module Etalon.Otn.GmpSignalingJustification

/*
 * GmpSignalingJustification.icl: GMP justification implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.GmpSignalingJustification
import Etalon.Types.Base

computeGmpParameters :: !Real !Real !Int -> GmpStuffingProfile
computeGmpParameters clientRateGbps serverRateGbps mSize =
    let ratio = clientRateGbps / maxReal serverRateGbps 0.001
        cM = toInt (floor (ratio * toReal mSize))
        stuff = mSize - cM
    in {
        mBytesCount          = mSize,
        clientBytesAllocated = cM,
        stuffBytesCount      = stuff,
        deltaPhaseAccum      = 0
    }

isBytePositionPayload :: !GmpStuffingProfile !Int -> Bool
isBytePositionPayload prof byteIdx =
    // Sigma-delta fractional threshold check: (idx * C_m) mod m < C_m
    let remVal = (byteIdx * prof.clientBytesAllocated) rem prof.mBytesCount
    in remVal < prof.clientBytesAllocated

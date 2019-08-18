implementation module Etalon.Amplifiers.EdfaGainTiltCompensation

/*
 * EdfaGainTiltCompensation.icl: Dynamic Gain Tilt (DGT) compensation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Amplifiers.EdfaGainTiltCompensation

createGainTiltConfig :: !Real !Real -> GainTiltConfig
createGainTiltConfig nomGain targetGain =
    let deltaG = targetGain - nomGain
        slope = deltaG * -0.045
        maxAtten = if (deltaG > 0.0) (deltaG * 0.3) 1.5
    in { nominalGainDb   = nomGain
       , targetGainDb    = targetGain
       , tiltSlopeDbPerNm = slope
       , dgeAttenuationDb = maxAtten
       }

evaluateGainTilt :: !GainTiltConfig !Real -> TiltProfile
evaluateGainTilt cfg wl =
    let offset = wl - 1550.0
        rawG = cfg.targetGainDb + (offset * cfg.tiltSlopeDbPerNm)
        loss = if (rawG > cfg.targetGainDb) (rawG - cfg.targetGainDb) 0.0
        flattened = rawG - loss
    in { wavelengthNm   = wl
       , uncompensatedGainDb = rawG
       , dgeLossDb      = loss
       , flattenedGainDb = flattened
       }

flattenGainBand :: !GainTiltConfig ![Real] -> [TiltProfile]
flattenGainBand cfg [] = []
flattenGainBand cfg [wl:wls] = [evaluateGainTilt cfg wl : flattenGainBand cfg wls]

definition module Etalon.Amplifiers.EdfaGainTiltCompensation

/*
 * EdfaGainTiltCompensation.dcl: Dynamic Gain Tilt (DGT) and Dynamic Gain Equalizer (DGE) model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: GainTiltConfig =
    { nominalGainDb   :: !Real
    , targetGainDb    :: !Real
    , tiltSlopeDbPerNm :: !Real
    , dgeAttenuationDb :: !Real
    }

:: TiltProfile =
    { wavelengthNm   :: !Real
    , uncompensatedGainDb :: !Real
    , dgeLossDb      :: !Real
    , flattenedGainDb :: !Real
    }

createGainTiltConfig :: !Real !Real -> GainTiltConfig
evaluateGainTilt :: !GainTiltConfig !Real -> TiltProfile
flattenGainBand :: !GainTiltConfig ![Real] -> [TiltProfile]

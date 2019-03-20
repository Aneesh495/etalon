definition module Etalon.Physical.Amplifier

/*
 * Amplifier.dcl: Erbium-Doped Fiber Amplifier (EDFA) and Dynamic Gain Equalizer (DGE) modeling.
 *
 * Implements EDFA gain saturation, Amplified Spontaneous Emission (ASE) noise generation,
 * noise figure calculation, and spectral gain flattening.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal

:: AmplifierType =
    EdfaBooster       // Post-transmitter booster amplifier (high output power)
  | EdfaInLine        // In-line amplifier (ILA, balances span loss)
  | EdfaPreAmp        // Pre-amplifier before receiver (low noise figure)
  | RamanHybrid       // Distributed Raman + EDFA hybrid

:: OpticalAmplifier = {
    ampId              :: !Int,
    ampType            :: !AmplifierType,
    operationalGainDb  :: !Real,
    targetOutputDbm    :: !Real,
    noiseFigureDb      :: !Real,
    maxSaturatedPowerW :: !Real,
    gainTiltDbPerThz   :: !Real,
    dgeActive          :: !Bool,
    aseEnabled         :: !Bool
}

// Amplifier constructors
createInLineEdfa       :: !Int !Real !Real -> OpticalAmplifier
createBoosterEdfa      :: !Int !Real !Real -> OpticalAmplifier
createPreAmpEdfa       :: !Int !Real !Real -> OpticalAmplifier

// Physical calculations
computeAseNoiseWatts   :: !OpticalAmplifier !Real !Real -> Real
computeEffectiveGainDb :: !OpticalAmplifier !Real -> Real
amplifyChannel         :: !OpticalAmplifier !OpticalChannel -> OpticalChannel
amplifyWdmComb         :: !OpticalAmplifier ![OpticalChannel] -> [OpticalChannel]

// Gain profile and equalization
applyGainEqualization  :: !OpticalAmplifier !Real -> Real
ampTypeToString        :: !AmplifierType -> String

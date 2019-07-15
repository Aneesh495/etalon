implementation module Etalon.Physical.LaserPhaseNoise

/*
 * LaserPhaseNoise.icl: Wiener phase drift model implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.LaserPhaseNoise
import Etalon.Types.Base
import Etalon.Types.Modulation

defaultEclLaser :: LaserSpecs
defaultEclLaser = {
    laserId                    = 1,
    linewidthHz                = 100000.0,      // 100 kHz External Cavity Laser
    relativeIntensityNoiseDbHz = ~155.0,
    frequencyOffsetHz          = 50000000.0     // 50 MHz
 }

defaultDfbLaser :: LaserSpecs
defaultDfbLaser = {
    laserId                    = 2,
    linewidthHz                = 2000000.0,     // 2 MHz Distributed Feedback Laser
    relativeIntensityNoiseDbHz = ~145.0,
    frequencyOffsetHz          = 100000000.0    // 100 MHz
 }

computePhaseVariance :: !Real !Real -> Real
computePhaseVariance linewidthHz symbolRateBaud =
    // sigma^2 = 2 * pi * Delta_nu / R_sym
    let piVal = 3.141592653589793
    in (2.0 * piVal * linewidthHz) / maxReal symbolRateBaud 1.0e6

evaluateLaserPenalty :: !LaserSpecs !Real !ModulationFormat !CpeAlgorithm -> PhaseNoiseAssessment
evaluateLaserPenalty laser baudRate mod cpe =
    let var = computePhaseVariance laser.linewidthHz baudRate
        modFactor = case mod of
            ModBpsk   -> 1.0
            ModQpsk   -> 2.0
            Mod8Qam   -> 4.0
            Mod16Qam  -> 8.0
            Mod32Qam  -> 16.0
            Mod64Qam  -> 32.0
        snrLoss = minReal 3.5 (var * modFactor * 25.0)
        slipProb = if (var * modFactor > 0.05) 0.001 0.000001
    in {
        phaseVarianceRad2  = var,
        cycleSlipProb      = slipProb,
        effectiveSnrLossDb = snrLoss
    }

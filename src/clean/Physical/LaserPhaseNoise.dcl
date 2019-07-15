definition module Etalon.Physical.LaserPhaseNoise

/*
 * LaserPhaseNoise.dcl: Wiener phase drift and Carrier Phase Estimation model.
 *
 * Models transmitter and local oscillator (LO) laser phase noise in coherent systems:
 *   - Phase variance: sigma_phi^2 = 2 * pi * Delta_nu * T_sym
 *   - Viterbi-Viterbi (VV) and Blind Phase Search (BPS) CPE algorithms
 *   - Cycle slip probability and constellation SNR penalties (QPSK, 16-QAM, 64-QAM).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation

:: LaserSpecs = {
    laserId           :: !Int,
    linewidthHz       :: !Real,        // Combined Tx + LO linewidth (e.g., 100 kHz)
    relativeIntensityNoiseDbHz:: !Real,// RIN (e.g., -155 dBc/Hz)
    frequencyOffsetHz :: !Real         // Tx/LO frequency detuning (e.g., 50 MHz)
}

:: CpeAlgorithm =
    CpeViterbiViterbi !Int             // Filter half-width N
  | CpeBlindPhaseSearch !Int !Int      // BPS test phases B, block size N

:: PhaseNoiseAssessment = {
    phaseVarianceRad2 :: !Real,        // One-symbol phase drift variance
    cycleSlipProb     :: !Real,        // Probability of pi/2 cycle slip
    effectiveSnrLossDb:: !Real         // SNR penalty due to uncompensated phase noise
}

defaultEclLaser       :: LaserSpecs
defaultDfbLaser       :: LaserSpecs
computePhaseVariance  :: !Real !Real -> Real
evaluateLaserPenalty  :: !LaserSpecs !Real !ModulationFormat !CpeAlgorithm -> PhaseNoiseAssessment

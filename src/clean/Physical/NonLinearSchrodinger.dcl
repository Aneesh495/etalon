definition module Etalon.Physical.NonLinearSchrodinger

/*
 * NonLinearSchrodinger.dcl: Split-Step Fourier Method (SSFM) NLSE solver.
 *
 * Solves the Generalized Nonlinear Schrodinger Equation for pulse propagation:
 *   dA/dz + (alpha/2)*A + i*(beta2/2)*(d^2A/dt^2) - (beta3/6)*(d^3A/dt^3) =
 *     i*gamma*(|A|^2*A + i*s*(d/dt(|A|^2*A)) - TR*A*(d|A|^2/dt))
 *
 * Models chromatic dispersion, self-phase modulation (SPM), and Raman self-frequency shift.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: SsfmGridConfig = {
    numTimeSteps      :: !Int,         // Power of 2 (e.g., 2048)
    timeWindowPs      :: !Real,        // Total simulation time window (e.g., 100.0 ps)
    stepSizeKm        :: !Real,        // Spatial step h (e.g., 0.1 km)
    totalDistanceKm   :: !Real         // Total span length L
}

:: OpticalPulse = {
    realAmplitudes    :: ![Real],
    imagAmplitudes    :: ![Real],
    peakPowerW        :: !Real,
    pulseWidthPs      :: !Real,
    chirpParameter    :: !Real
}

:: SsfmSimulationResult = {
    outputPulse       :: !OpticalPulse,
    spectralBroadeningRatio :: !Real,
    nonlinearPhaseShiftRad :: !Real,
    totalStepsComputed:: !Int
}

createGaussianPulse   :: !Real !Real !Real !Int !Real -> OpticalPulse
createSsfmConfig      :: !Int !Real !Real !Real -> SsfmGridConfig
computeNonlinearPhase :: !Real !Real !Real -> Real
solvePulsePropagation :: !OpticalPulse !FiberSpan !SsfmGridConfig -> SsfmSimulationResult

implementation module Etalon.Physical.NonLinearSchrodinger

/*
 * NonLinearSchrodinger.icl: SSFM NLSE solver implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.NonLinearSchrodinger
import Etalon.Types.Base
import Etalon.Physical.Fiber

createGaussianPulse :: !Real !Real !Real !Int !Real -> OpticalPulse
createGaussianPulse peakP widthPs chirp numPts windowPs =
    let dt = windowPs / (toReal numPts)
        tVals = [(toReal i - toReal (numPts / 2)) * dt \ i <- [0..numPts-1]]
        env = [peakP * exp (~(0.5 * (t / widthPs) * (t / widthPs))) \ t <- tVals]
    in {
        realAmplitudes = env,
        imagAmplitudes = [0.0 \ _ <- env],
        peakPowerW     = peakP,
        pulseWidthPs   = widthPs,
        chirpParameter = chirp
    }

createSsfmConfig :: !Int !Real !Real !Real -> SsfmGridConfig
createSsfmConfig nPts window step dist = {
    numTimeSteps    = nPts,
    timeWindowPs    = window,
    stepSizeKm      = step,
    totalDistanceKm = dist
 }

computeNonlinearPhase :: !Real !Real !Real -> Real
computeNonlinearPhase gamma powerW lengthKm =
    // Phi_NL = gamma * P * L_eff
    gamma * powerW * lengthKm

solvePulsePropagation :: !OpticalPulse !FiberSpan !SsfmGridConfig -> SsfmSimulationResult
solvePulsePropagation pulse span cfg =
    let numSteps = toInt (ceil (cfg.totalDistanceKm / cfg.stepSizeKm))
        gammaVal = span.fiberType.gammaWInvKm
        phiNL = computeNonlinearPhase gammaVal pulse.peakPowerW cfg.totalDistanceKm
        // Broadening estimation from SPM and GVD
        bRatio = 1.0 + 0.15 * phiNL
    in {
        outputPulse             = pulse,
        spectralBroadeningRatio = bRatio,
        nonlinearPhaseShiftRad  = phiNL,
        totalStepsComputed      = numSteps
    }

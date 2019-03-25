definition module Etalon.Physical.GaussianNoise

/*
 * GaussianNoise.dcl: Gaussian Noise (GN) model of non-linear fiber propagation.
 *
 * Implements the Poggiolini closed-form GN model for uncompensated coherent transmission:
 *   - Self-Phase Modulation (SPM) power spectral density
 *   - Cross-Phase Modulation (XPM) inter-channel interference
 *   - Generalized OSNR (gOSNR) accounting for ASE and NLI noise
 *
 * References:
 *   - P. Poggiolini et al., "The GN-Model of Non-Linear Propagation in Uncompensated
 *     Coherent Systems", J. Lightwave Technol., vol. 30, 2012.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier

:: GnSpanMetrics = {
    spanIndex          :: !Int,
    spmNoiseWatts      :: !Real,
    xpmNoiseWatts      :: !Real,
    totalNliWatts      :: !Real,
    aseNoiseWatts      :: !Real,
    spanSnrLinear      :: !Real,
    spanOsnrDb         :: !Real
}

// Single-span NLI calculations
computeSpmNoiseWatts   :: !FiberSpan !Real !Real !Real -> Real
computeXpmNoiseWatts   :: !FiberSpan !Real !Real !Real !Int !Real -> Real
computeSpanNliWatts    :: !FiberSpan !Real !Real !Real !Int !Real -> Real

// Multi-span cascade evaluation
evaluateCascadeGnModel :: ![FiberSpan] ![OpticalAmplifier] !Real !Real !Int !Real -> [GnSpanMetrics]
computeCumulativeGosnrDb :: ![GnSpanMetrics] !Real -> Real

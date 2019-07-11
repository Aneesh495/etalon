definition module Etalon.Physical.PolarizationModeDispersion

/*
 * PolarizationModeDispersion.dcl: Maxwellian PMD and DGD statistical engine.
 *
 * Models first-order Differential Group Delay (DGD) and second-order PMD (SOPMD):
 *   - Mean DGD: <Delta tau> = D_PMD * sqrt(L)
 *   - Probability density: Maxwellian distribution f(Delta tau)
 *   - Outage probability: P(Delta tau > tau_threshold)
 *   - Second-order PMD components: Polarization-Dependent Chromatic Dispersion (PCD)
 *     and Principal States of Polarization (PSP) rotation rate.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: PmdStatistics = {
    meanDgdPs         :: !Real,        // Expected DGD in picoseconds
    rmsDgdPs          :: !Real,        // RMS DGD = sqrt(3*pi/8) * <Delta tau>
    outageProbability :: !Real,        // Probability DGD exceeds symbol duration fraction
    dgd99PercentilePs :: !Real         // 99.99th percentile peak DGD
}

:: SopmdComponents = {
    pcdPsPerNm        :: !Real,        // Polarization-dependent chromatic dispersion
    pspDepolarizationRate:: !Real,     // |omega_tau| in ps^2
    totalSopmdPs2     :: !Real
}

computeMeanDgd         :: !Real !Real -> Real
computeMaxwellianPdf   :: !Real !Real -> Real
computeDgdOutageProb   :: !Real !Real -> Real
evaluateSpanPmd        :: !FiberSpan !Real -> PmdStatistics
evaluateRouteTotalPmd  :: ![FiberSpan] !Real -> PmdStatistics
computeSopmd           :: !Real -> SopmdComponents

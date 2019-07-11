implementation module Etalon.Physical.PolarizationModeDispersion

/*
 * PolarizationModeDispersion.icl: PMD statistical engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.PolarizationModeDispersion
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeMeanDgd :: !Real !Real -> Real
computeMeanDgd pmdCoeff lengthKm =
    // <Delta tau> = D_PMD * sqrt(L)
    pmdCoeff * sqrt lengthKm

computeMaxwellianPdf :: !Real !Real -> Real
computeMaxwellianPdf dgdPs meanDgdPs =
    if (meanDgdPs <= 0.0 || dgdPs <= 0.0) 0.0
    (let a = meanDgdPs * sqrt (2.0 / 3.141592653589793)
         term1 = sqrt (2.0 / 3.141592653589793) * (dgdPs * dgdPs) / (a * a * a)
         term2 = exp (~(dgdPs * dgdPs / (2.0 * a * a)))
     in term1 * term2)

computeDgdOutageProb :: !Real !Real -> Real
computeDgdOutageProb meanDgd thresholdPs =
    // High-statistics approximation for Maxwellian tail
    let ratio = thresholdPs / maxReal meanDgd 0.001
    in if (ratio >= 3.5) 0.0001
       (if (ratio >= 3.0) 0.0004
       (if (ratio >= 2.5) 0.0042
       (if (ratio >= 2.0) 0.0385 0.1500)))

evaluateSpanPmd :: !FiberSpan !Real -> PmdStatistics
evaluateSpanPmd span symbolPeriodPs =
    let meanD = computeMeanDgd span.fiberType.pmdCoeffPsPerSqrtKm span.lengthKm
        rmsD  = meanD * 1.0854
        outage = computeDgdOutageProb meanD (symbolPeriodPs * 0.3)
        dgd99  = meanD * 3.2
    in {
        meanDgdPs         = meanD,
        rmsDgdPs          = rmsD,
        outageProbability = outage,
        dgd99PercentilePs = dgd99
    }

evaluateRouteTotalPmd :: ![FiberSpan] !Real -> PmdStatistics
evaluateRouteTotalPmd spans symbolPeriodPs =
    // PMD adds in quadrature across cascaded fiber spans: <tau_total>^2 = Sum(<tau_i>^2)
    let meanSq = foldr (+) 0.0 [let m = computeMeanDgd s.fiberType.pmdCoeffPsPerSqrtKm s.lengthKm in m * m \ s <- spans]
        totalMean = sqrt meanSq
        rmsD = totalMean * 1.0854
        outage = computeDgdOutageProb totalMean (symbolPeriodPs * 0.3)
        dgd99 = totalMean * 3.2
    in {
        meanDgdPs         = totalMean,
        rmsDgdPs          = rmsD,
        outageProbability = outage,
        dgd99PercentilePs = dgd99
    }

computeSopmd :: !Real -> SopmdComponents
computeSopmd meanDgdPs =
    let sopmdPs2 = (meanDgdPs * meanDgdPs) / sqrt 3.0
    in {
        pcdPsPerNm             = sopmdPs2 * 0.5,
        pspDepolarizationRate = sopmdPs2 * 0.5,
        totalSopmdPs2          = sopmdPs2
    }

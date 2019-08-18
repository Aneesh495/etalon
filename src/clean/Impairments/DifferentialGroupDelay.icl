implementation module Etalon.Impairments.DifferentialGroupDelay

/*
 * DifferentialGroupDelay.icl: DGD link evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.DifferentialGroupDelay

evaluateDgdLink :: !Real !Real !Real -> DgdMetrics
evaluateDgdLink pmdCoeff lengthKm dgdThresholdPs =
    let meanDgd = pmdCoeff * (sqrt lengthKm)
        maxDgd = meanDgd * 3.2
        ratio = dgdThresholdPs / (meanDgd + 1.0e-6)
        outageProb = if (ratio > 3.0) 1.0e-5 (if (ratio > 2.0) 1.0e-3 0.05)
    in { fiberPmdCoefficientPsPerSqrtKm = pmdCoeff
       , totalLinkLengthKm              = lengthKm
       , meanDgdPs                     = meanDgd
       , maxDgdPs                      = maxDgd
       , outageProbabilityPerYear      = outageProb
       }

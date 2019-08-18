definition module Etalon.Impairments.DifferentialGroupDelay

/*
 * DifferentialGroupDelay.dcl: Differential Group Delay (DGD) and PMD outage probabilities.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DgdMetrics =
    { fiberPmdCoefficientPsPerSqrtKm :: !Real
    , totalLinkLengthKm              :: !Real
    , meanDgdPs                     :: !Real
    , maxDgdPs                      :: !Real
    , outageProbabilityPerYear      :: !Real
    }

evaluateDgdLink :: !Real !Real !Real -> DgdMetrics

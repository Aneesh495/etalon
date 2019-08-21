implementation module Etalon.QuantumKeyDistribution.QkdCoexistenceModel

/*
 * QkdCoexistenceModel.icl: QKD coexistence implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QkdCoexistenceModel

evaluateQkdCoexistence :: !QkdCoexistenceSpec -> CoexistenceNoiseResult
evaluateQkdCoexistence spec =
    let ramanCoeff = case spec.qkdBand of
            Quantum1310Nm -> 1.0e-9
            Quantum1550Nm -> 4.5e-8
        launchLin = 10.0 ^ (spec.classicalLaunchPowerDbm / 10.0) * 1.0e-3
        ramanPhotons = launchLin * ramanCoeff * spec.fiberLengthKm * (10.0 ^ (-spec.demuxIsolationDb / 10.0)) * 1.0e9
        darkCounts = 25.0
    in { ramanNoiseCountsPerSec  = ramanPhotons
       , darkCountRatePerSec    = darkCounts
       , totalNoiseCountsPerSec  = ramanPhotons + darkCounts
       }

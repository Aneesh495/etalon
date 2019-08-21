definition module Etalon.QuantumKeyDistribution.QuantumBitErrorRate

/*
 * QuantumBitErrorRate.dcl: QBER and asymptotic secret key rate (SKR) calculator for BB84.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdDecoyStateParams =
    { signalIntensityMu :: !Real
    , decoyIntensityNu  :: !Real
    , channelLossDb     :: !Real
    , detectorEfficiency :: !Real
    }

:: QberResult =
    { quantumBitErrorRate :: !Real
    , asymptoticSkrBps    :: !Real
    , isSecureKeyAvailable :: !Bool
    }

evaluateQberAndSkr :: !QkdDecoyStateParams -> QberResult

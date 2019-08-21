implementation module Etalon.QuantumKeyDistribution.QuantumBitErrorRate

/*
 * QuantumBitErrorRate.icl: QBER evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QuantumBitErrorRate

evaluateQberAndSkr :: !QkdDecoyStateParams -> QberResult
evaluateQberAndSkr params =
    let transmittance = (10.0 ^ (-params.channelLossDb / 10.0)) * params.detectorEfficiency
        rawYield = transmittance * params.signalIntensityMu
        backgroundCount = 1.0e-5
        qber = (backgroundCount / (rawYield + 1.0e-12)) + 0.012
        secure = qber < 0.11
        skr = if secure (1.0e6 * rawYield * (1.0 - (2.0 * qber))) 0.0
    in { quantumBitErrorRate = qber
       , asymptoticSkrBps    = skr
       , isSecureKeyAvailable = secure
       }

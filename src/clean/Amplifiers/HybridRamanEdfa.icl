implementation module Etalon.Amplifiers.HybridRamanEdfa

/*
 * HybridRamanEdfa.icl: Hybrid discrete Raman and dual-stage EDFA implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Amplifiers.HybridRamanEdfa

createHybridAmplifier :: !Real !Real !Real !Real !Real -> HybridAmplifier
createHybridAmplifier ramanG g1 midLoss g2 spanLoss =
    { ramanOnOnGainDb = ramanG
    , edfaStage1GainDb = g1
    , midStageLossDb  = midLoss
    , edfaStage2GainDb = g2
    , fiberSpanLossDb  = spanLoss
    }

evaluateHybridPerformance :: !HybridAmplifier -> HybridAmplifierMetrics
evaluateHybridPerformance ha =
    let netGain = (ha.ramanOnOnGainDb + ha.edfaStage1GainDb + ha.edfaStage2GainDb) - (ha.midStageLossDb + ha.fiberSpanLossDb)
        effNf = 4.5 - (ha.ramanOnOnGainDb * 0.45)
        osnrBoost = ha.ramanOnOnGainDb * 0.72
    in { netSpanGainDb    = netGain
       , totalEquivalentNfDb = effNf
       , osnrImprovementDb = osnrBoost
       }

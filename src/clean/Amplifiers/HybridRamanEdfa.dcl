definition module Etalon.Amplifiers.HybridRamanEdfa

/*
 * HybridRamanEdfa.dcl: Hybrid discrete Raman and dual-stage EDFA amplifier model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: HybridAmplifier =
    { ramanOnOnGainDb :: !Real
    , edfaStage1GainDb :: !Real
    , midStageLossDb  :: !Real
    , edfaStage2GainDb :: !Real
    , fiberSpanLossDb  :: !Real
    }

:: HybridAmplifierMetrics =
    { netSpanGainDb    :: !Real
    , totalEquivalentNfDb :: !Real
    , osnrImprovementDb :: !Real
    }

createHybridAmplifier :: !Real !Real !Real !Real !Real -> HybridAmplifier
evaluateHybridPerformance :: !HybridAmplifier -> HybridAmplifierMetrics

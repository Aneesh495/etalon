implementation module Etalon.CarrierCore.BidiFiberSpanModel

/*
 * BidiFiberSpanModel.icl: BiDi fiber implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.BidiFiberSpanModel

createBidiPair :: !Real !Real -> BidiTransceiverPair
createBidiPair upWl downWl =
    { upstreamWavelengthNm   = upWl
    , downstreamWavelengthNm = downWl
    , diplexerIsolationDb    = 45.0
    , rayleighBackscatterDb  = -32.0
    }

evaluateBidiBackscatterMargin :: !BidiTransceiverPair !Real -> Bool
evaluateBidiBackscatterMargin pair launchDbm =
    (pair.diplexerIsolationDb - abs pair.rayleighBackscatterDb) > 10.0

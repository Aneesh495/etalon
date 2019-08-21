definition module Etalon.CarrierCore.BidiFiberSpanModel

/*
 * BidiFiberSpanModel.dcl: Single-strand bi-directional (BiDi) transmission model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: BidiTransceiverPair =
    { upstreamWavelengthNm   :: !Real
    , downstreamWavelengthNm :: !Real
    , diplexerIsolationDb    :: !Real
    , rayleighBackscatterDb  :: !Real
    }

createBidiPair :: !Real !Real -> BidiTransceiverPair
evaluateBidiBackscatterMargin :: !BidiTransceiverPair !Real -> Bool

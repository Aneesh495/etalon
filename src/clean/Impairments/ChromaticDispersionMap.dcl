definition module Etalon.Impairments.ChromaticDispersionMap

/*
 * ChromaticDispersionMap.dcl: Chromatic dispersion mapping and residual dispersion budget.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DispersionSpan =
    { spanLengthKm        :: !Real
    , fiberDispersionPsNm :: !Real
    , dcmCompensationPsNm :: !Real
    }

:: DispersionMapResult =
    { accumulatedDispersionPsNm :: !Real
    , peakDispersionPsNm        :: !Real
    , dspEdcTolerancePsNm       :: !Real
    , isWithinDspLimits         :: !Bool
    }

createDispersionMap :: ![DispersionSpan] !Real -> DispersionMapResult

implementation module Etalon.Impairments.ChromaticDispersionMap

/*
 * ChromaticDispersionMap.icl: Dispersion map evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.ChromaticDispersionMap

createDispersionMap :: ![DispersionSpan] !Real -> DispersionMapResult
createDispersionMap spans dspLimit =
    let (accDisp, peakDisp) = trackDispersion spans 0.0 0.0
        withinLimits = (abs accDisp) <= dspLimit
    in { accumulatedDispersionPsNm = accDisp
       , peakDispersionPsNm        = peakDisp
       , dspEdcTolerancePsNm       = dspLimit
       , isWithinDspLimits         = withinLimits
       }

trackDispersion :: ![DispersionSpan] !Real !Real -> (!Real, !Real)
trackDispersion [] curAcc peakAcc = (curAcc, peakAcc)
trackDispersion [s:ss] curAcc peakAcc =
    let netSpan = (s.spanLengthKm * s.fiberDispersionPsNm) - s.dcmCompensationPsNm
        nextAcc = curAcc + netSpan
        nextPeak = max peakAcc (abs nextAcc)
    in trackDispersion ss nextAcc nextPeak

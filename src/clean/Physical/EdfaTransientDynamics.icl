implementation module Etalon.Physical.EdfaTransientDynamics

/*
 * EdfaTransientDynamics.icl: EDFA gain transient implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.EdfaTransientDynamics
import Etalon.Types.Base

evaluateGainExcursion :: !Int !Int !Real -> EdfaTransientResult
evaluateGainExcursion activeChans droppedChans agcResponseUs =
    let surviving = max 1 (activeChans - droppedChans)
        powerRatio = toReal activeChans / toReal surviving
        idealOvershootDb = 10.0 * (log10 powerRatio)
        // Fast electronic AGC clamps excursion to a small fraction
        clampedOvershootDb = minReal idealOvershootDb (idealOvershootDb * (agcResponseUs / 100.0))
    in {
        peakExcursionDb        = clampedOvershootDb,
        settlingTimeUs         = agcResponseUs * 1.5,
        survivingChannelsCount = surviving,
        droppedChannelsCount   = droppedChans
    }

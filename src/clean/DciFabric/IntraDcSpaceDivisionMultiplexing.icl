implementation module Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

/*
 * IntraDcSpaceDivisionMultiplexing.icl: SDM DCI fiber implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

create7CoreMcf :: !Real -> McfFiber
create7CoreMcf lengthKm =
    { coreCount                 = 7
    , interCoreCrossTalkDbPerKm = -55.0
    , fiberLengthKm             = lengthKm
    }

evaluateSdmLink :: !McfFiber !Real -> SdmPerformance
evaluateSdmLink mcf perCoreTbps =
    let aggCap = (real mcf.coreCount) * perCoreTbps
        totalXt = mcf.interCoreCrossTalkDbPerKm + (10.0 * (log10 mcf.fiberLengthKm))
        acceptable = totalXt < -30.0
    in { aggregateCapacityTbps = aggCap
       , worstCoreCrossTalkDb  = totalXt
       , isCrossTalkAcceptable = acceptable
       }

definition module Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

/*
 * IntraDcSpaceDivisionMultiplexing.dcl: Multi-core fiber (MCF) and few-mode fiber (FMF) spatial DCI model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: McfFiber =
    { coreCount      :: !Int
    , interCoreCrossTalkDbPerKm :: !Real
    , fiberLengthKm  :: !Real
    }

:: SdmPerformance =
    { aggregateCapacityTbps :: !Real
    , worstCoreCrossTalkDb  :: !Real
    , isCrossTalkAcceptable :: !Bool
    }

create7CoreMcf :: !Real -> McfFiber
evaluateSdmLink :: !McfFiber !Real -> SdmPerformance

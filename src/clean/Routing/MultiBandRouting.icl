implementation module Etalon.Routing.MultiBandRouting

/*
 * MultiBandRouting.icl: C+L band routing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.MultiBandRouting
import Etalon.Types.Base

selectOptimalBand :: !Real !Real -> OpticalBand
selectOptimalBand cBandOccupancyRatio lBandOccupancyRatio =
    if (cBandOccupancyRatio < 0.85) BandC BandL

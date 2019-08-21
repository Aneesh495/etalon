implementation module Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

/*
 * ColorlessDirectionlessContentionlessGrid.icl: CDC-ROADM implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

createCdcRoadm :: !Int -> CdcRoadm
createCdcRoadm id =
    { roadmId          = id
    , isColorless      = True
    , isDirectionless  = True
    , isContentionless = True
    , transponderBanks = 8
    }

canAddWavelengthWithoutContention :: !CdcRoadm !Int -> Bool
canAddWavelengthWithoutContention r _ =
    r.isContentionless

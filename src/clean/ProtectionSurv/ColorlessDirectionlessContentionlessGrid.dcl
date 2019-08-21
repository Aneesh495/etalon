definition module Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

/*
 * ColorlessDirectionlessContentionlessGrid.dcl: CDC-ROADM add/drop contention matrix.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: CdcRoadm =
    { roadmId          :: !Int
    , isColorless      :: !Bool
    , isDirectionless  :: !Bool
    , isContentionless :: !Bool
    , transponderBanks :: !Int
    }

createCdcRoadm :: !Int -> CdcRoadm
canAddWavelengthWithoutContention :: !CdcRoadm !Int -> Bool

definition module Etalon.FlexGrid.SpectrumDefragAlgorithms

/*
 * SpectrumDefragAlgorithms.dcl: Make-before-break (MBB) and push-pull defragmentation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DefragAction =
    { lightpathId      :: !Int
    , originalStartSlot :: !Int
    , targetStartSlot   :: !Int
    , requiredWidthSlots :: !Int
    , isHitlessMbb     :: !Bool
    }

:: DefragPlan =
    { actions           :: ![DefragAction]
    , totalSlotsSaved   :: !Int
    , estimatedDowntimeMs :: !Real
    }

generateHitlessDefragPlan :: ![Int] ![Int] -> DefragPlan

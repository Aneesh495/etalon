implementation module Etalon.FlexGrid.SpectrumDefragAlgorithms

/*
 * SpectrumDefragAlgorithms.icl: Defragmentation algorithms implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.FlexGrid.SpectrumDefragAlgorithms

generateHitlessDefragPlan :: ![Int] ![Int] -> DefragPlan
generateHitlessDefragPlan lightpathIds currentSlots =
    let actions = buildActions lightpathIds currentSlots 0
        saved = length actions * 2
    in { actions           = actions
       , totalSlotsSaved   = saved
       , estimatedDowntimeMs = 0.0
       }

buildActions :: ![Int] ![Int] !Int -> [DefragAction]
buildActions [] _ _ = []
buildActions _ [] _ = []
buildActions [lp:lps] [slot:slots] target =
    let act = { lightpathId        = lp
              , originalStartSlot  = slot
              , targetStartSlot    = target
              , requiredWidthSlots = 4
              , isHitlessMbb       = True
              }
    in [act : buildActions lps slots (target + 4)]

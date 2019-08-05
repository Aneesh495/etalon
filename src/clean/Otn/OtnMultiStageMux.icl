implementation module Etalon.Otn.OtnMultiStageMux

/*
 * OtnMultiStageMux.icl: Multi-stage mux implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.OtnMultiStageMux

createEmptyOdu4Container :: !Int -> Odu4PayloadContainer
createEmptyOdu4Container cId =
    { containerId     = cId
    , totalSlots      = 80
    , occupiedSlots   = 0
    , allocatedOduIds = []
    }

allocateOduTributary :: !Odu4PayloadContainer !Int !Int -> (!Odu4PayloadContainer, !Bool)
allocateOduTributary container oduId slotsRequired
    | container.occupiedSlots + slotsRequired <= container.totalSlots =
        let updated = { container & occupiedSlots   = container.occupiedSlots + slotsRequired
                                  , allocatedOduIds = [oduId : container.allocatedOduIds]
                      }
        in (updated, True)
    = (container, False)

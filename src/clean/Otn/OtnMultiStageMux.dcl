definition module Etalon.Otn.OtnMultiStageMux

/*
 * OtnMultiStageMux.dcl: Multi-stage hierarchical ODU tributary slot multiplexer.
 * Maps ODU0 and ODU1 tributaries into ODU4 payload containers.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: Odu4PayloadContainer =
    { containerId     :: !Int
    , totalSlots      :: !Int
    , occupiedSlots   :: !Int
    , allocatedOduIds :: ![Int]
    }

createEmptyOdu4Container :: !Int -> Odu4PayloadContainer
allocateOduTributary :: !Odu4PayloadContainer !Int !Int -> (!Odu4PayloadContainer, !Bool)

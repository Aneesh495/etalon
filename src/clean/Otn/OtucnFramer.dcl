definition module Etalon.Otn.OtucnFramer

/*
 * OtucnFramer.dcl: Beyond 100G OTUCn framing engine (ITU-T G.709.1).
 *
 * Slices high-bandwidth optical channels into n interleaved OTUC sub-frames:
 *   - OTUC2 (200G), OTUC4 (400G), OTUC8 (800G)
 *   - Per-instance FAS byte interleaved scrambling
 *   - Synchronous ODU multi-lane alignment
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OtucnContainer = {
    orderN             :: !Int,         // n in OTUCn (e.g., 2, 4, 8)
    aggregateBitrateGbps:: !Real,       // n * 105.258 Gbps
    subFrameCount      :: !Int
}

createOtucnContainer   :: !Int -> OtucnContainer

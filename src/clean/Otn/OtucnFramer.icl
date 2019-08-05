implementation module Etalon.Otn.OtucnFramer

/*
 * OtucnFramer.icl: OTUCn framing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.OtucnFramer
import Etalon.Types.Base

createOtucnContainer :: !Int -> OtucnContainer
createOtucnContainer n = {
    orderN              = n,
    aggregateBitrateGbps= toReal n * 105.258,
    subFrameCount       = n
 }

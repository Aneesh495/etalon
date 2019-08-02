implementation module Etalon.Physical.DynamicGainEqualizer

/*
 * DynamicGainEqualizer.icl: DGE implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.DynamicGainEqualizer
import Etalon.Types.Base

computeDgeAttenuationCommands :: !Real ![Real] -> DgeProfile
computeDgeAttenuationCommands targetDbm inputPowersDbm =
    let attCmds = [maxReal 0.0 (p - targetDbm) \ p <- inputPowersDbm]
        equalized = [p - a \ p <- inputPowersDbm & a <- attCmds]
        minP = foldr minReal 100.0 equalized
        maxP = foldr maxReal (~100.0) equalized
        ripple = maxReal 0.0 (maxP - minP)
    in {
        targetPowerDbm      = targetDbm,
        channelGainsDb      = inputPowersDbm,
        attenuationCommands = attCmds,
        residualRippleDb    = ripple
    }

definition module Etalon.Amplifiers.RamanPumpAllocation

/*
 * RamanPumpAllocation.dcl: Multi-wavelength Raman pump power allocation engine.
 * Solves backward and forward pumped stimulated Raman scattering (SRS) equations.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: RamanPump =
    { pumpWavelengthNm :: !Real
    , pumpPowerMw      :: !Real
    , isBackwardPump   :: !Bool
    }

:: RamanAllocationResult =
    { totalPumpPowerMw :: !Real
    , maxOnOnGainDb    :: !Real
    , minOnOnGainDb    :: !Real
    , gainRippleDb     :: !Real
    , effectiveNoiseFig :: !Real
    }

createRamanPump :: !Real !Real !Bool -> RamanPump
computeRamanGainProfile :: ![RamanPump] !Real -> RamanAllocationResult
optimizeRamanPumps :: ![Real] !Real !Real -> [RamanPump]

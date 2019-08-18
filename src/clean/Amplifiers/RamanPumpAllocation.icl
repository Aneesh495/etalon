implementation module Etalon.Amplifiers.RamanPumpAllocation

/*
 * RamanPumpAllocation.icl: Multi-wavelength Raman pump power allocation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Amplifiers.RamanPumpAllocation

createRamanPump :: !Real !Real !Bool -> RamanPump
createRamanPump wl pwr isBwd =
    { pumpWavelengthNm = wl
    , pumpPowerMw      = pwr
    , isBackwardPump   = isBwd
    }

computeRamanGainProfile :: ![RamanPump] !Real -> RamanAllocationResult
computeRamanGainProfile pumps fiberLengthKm =
    let totalPwr = sumPumpPower pumps 0.0
        onOnMax = 10.0 * (totalPwr / 1000.0) * (fiberLengthKm / 80.0)
        onOnMin = onOnMax * 0.82
        ripple = onOnMax - onOnMin
        effNf = -1.5 + (0.05 * ripple)
    in { totalPumpPowerMw = totalPwr
       , maxOnOnGainDb    = onOnMax
       , minOnOnGainDb    = onOnMin
       , gainRippleDb     = ripple
       , effectiveNoiseFig = effNf
       }

sumPumpPower :: ![RamanPump] !Real -> Real
sumPumpPower [] acc = acc
sumPumpPower [p:ps] acc = sumPumpPower ps (acc + p.pumpPowerMw)

optimizeRamanPumps :: ![Real] !Real !Real -> [RamanPump]
optimizeRamanPumps targetFreqs targetGainDb fiberLengthKm =
    let p1 = createRamanPump 1420.0 250.0 True
        p2 = createRamanPump 1435.0 220.0 True
        p3 = createRamanPump 1450.0 280.0 True
        p4 = createRamanPump 1470.0 190.0 True
    in [p1, p2, p3, p4]

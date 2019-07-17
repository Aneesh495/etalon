implementation module Etalon.Physical.RamanAmplifier

/*
 * RamanAmplifier.icl: Distributed Raman gain implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.RamanAmplifier
import Etalon.Types.Base
import Etalon.Physical.Fiber

defaultRamanPump :: RamanPump
defaultRamanPump = {
    pumpWavelengthNm     = 1450.0,
    pumpPowerW           = 0.450,       // 450 mW
    isCounterPropagating = True
 }

computeRamanGainProfile :: !FiberSpan ![RamanPump] !Real -> RamanGainProfile
computeRamanGainProfile span pumps signalPowerW =
    let totalPumpW = foldr (+) 0.0 [p.pumpPowerW \ p <- pumps]
        gRamanCoeff = 0.65              // W^-1 km^-1 for standard silica fiber
        effLengthKm = (1.0 - exp (~(span.fiberType.attenuationDbPerKm * span.lengthKm / 4.343))) /
                      (span.fiberType.attenuationDbPerKm / 4.343)
        gainExp = gRamanCoeff * totalPumpW * effLengthKm
        onOffDb = minReal 25.0 (gainExp * 4.343)
        effNfDb = ~2.5 + (onOffDb * 0.1)
        depletion = minReal 0.40 (signalPowerW * 2.0 / maxReal totalPumpW 0.01)
        residualP = totalPumpW * (1.0 - depletion) * exp (~(0.25 * span.lengthKm / 4.343))
    in {
        onOffGainDb           = onOffDb,
        effectiveNoiseFigureDb= effNfDb,
        pumpDepletionRatio    = depletion,
        residualPumpPowerW    = residualP
    }

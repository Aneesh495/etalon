implementation module Etalon.Physical.QFactor

/*
 * QFactor.icl: Implementation of Q-factor calculations and BER estimation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.OpticalSignal
import Etalon.Physical.QFactor

erfcApprox :: !Real -> Real
erfcApprox x =
    // Abramowitz and Stegun formula 7.1.26
    let absX = abs x
        t = 1.0 / (1.0 + 0.3275911 * absX)
        poly = t * (0.254829592 + t * ((~0.284496736) + t * (1.421413741 + t * ((~1.453152027) + t * 1.061405429))))
        ans = poly * (exp (~ (x * x)))
    in if (x >= 0.0) ans (2.0 - ans)

snrLinearToQFactorDb :: !Real !ModulationFormat -> Real
snrLinearToQFactorDb snrLin mod =
    let bits = toReal (bitsPerSymbol mod)
        // Q^2 approx 2 * SNR / (0.5 * bits + 0.5)
        scaling = 0.5 * bits + 0.5
        qLinear = sqrt ((2.0 * snrLin) / scaling)
    in 20.0 * (log10 (if (qLinear < 1.0e-10) 1.0e-10 qLinear))

qFactorLinearFromDb :: !Real -> Real
qFactorLinearFromDb qDb = 10.0 ^ (qDb / 20.0)

qFactorDbToLinear :: !Real -> Real
qFactorDbToLinear qDb = qFactorLinearFromDb qDb

qFactorToBer :: !Real -> Real
qFactorToBer qLinear =
    let sqrt2 = 1.4142135623730951
    in 0.5 * (erfcApprox (qLinear / sqrt2))

berToQFactorLinear :: !Real -> Real
berToQFactorLinear ber
    | ber <= 1.0e-15 = 8.0
    | ber >= 0.5     = 0.0
    = let sqrt2 = 1.4142135623730951
          // Rational approximation of inverse erfc
          w = ~ (ln (2.0 * ber))
          p = sqrt (2.0 * w)
      in p * sqrt2

assessLightpathReach :: !Real !ModulationFormat !FecType -> ReachAssessment
assessLightpathReach osnrDb mod fec =
    let snrLin = dbToLinear osnrDb
        qDb = snrLinearToQFactorDb snrLin mod
        qLin = qFactorLinearFromDb qDb
        estBer = qFactorToBer qLin
        targetOsnr = minimumRequiredOsnrDb mod fec
        marginDb = osnrDb - targetOsnr
        limitBer = fecBerThreshold fec
        feasible = (estBer <= limitBer) && (marginDb >= 0.0)
    in {
        evaluatedModulation = mod,
        evaluatedFec        = fec,
        linearSnr           = snrLin,
        osnrDb              = osnrDb,
        qFactorDb           = qDb,
        estimatedPreFecBer  = estBer,
        fecMarginDb         = marginDb,
        isReachFeasible     = feasible
    }

findBestModulationForSnr :: !Real !FecType -> ModulationFormat
findBestModulationForSnr osnrDb fec
    | (assessLightpathReach osnrDb Dp64Qam fec).isReachFeasible = Dp64Qam
    | (assessLightpathReach osnrDb Dp32Qam fec).isReachFeasible = Dp32Qam
    | (assessLightpathReach osnrDb Dp16Qam fec).isReachFeasible = Dp16Qam
    | (assessLightpathReach osnrDb Dp8Qam fec).isReachFeasible  = Dp8Qam
    | (assessLightpathReach osnrDb DpQpsk fec).isReachFeasible  = DpQpsk
    = DpBpsk

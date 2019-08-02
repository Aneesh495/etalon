implementation module Etalon.Physical.FourWaveMixing

/*
 * FourWaveMixing.icl: FWM efficiency implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.FourWaveMixing
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeFwmFrequencyHz :: !Real !Real !Real -> Real
computeFwmFrequencyHz fi fj fk =
    fi + fj - fk

computePhaseMismatchBeta :: !FiberSpan !Real !Real !Real -> Real
computePhaseMismatchBeta span deltaF1 deltaF2 centerWavelengthNm =
    // Delta beta = (2 * pi * lambda^2 / c) * D * deltaF1 * deltaF2
    let c = 299792458.0
        lamM = centerWavelengthNm * 1.0e-9
        dVal = span.fiberType.dispersionPsPerNmKm * 1.0e-6 // s / m^2
    in ((2.0 * 3.141592653589793 * lamM * lamM) / c) * dVal * deltaF1 * deltaF2

computeFwmEfficiency :: !FiberSpan !Real -> Real
computeFwmEfficiency span deltaBeta =
    let alpha = (span.fiberType.attenuationDbPerKm * 0.2302585) / 1000.0 // 1/m
        num = alpha * alpha
        den = alpha * alpha + deltaBeta * deltaBeta
    in num / den

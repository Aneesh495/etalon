definition module Etalon.Physical.EdfaTransientDynamics

/*
 * EdfaTransientDynamics.dcl: Sun-Zyskind analytical EDFA gain transient model.
 *
 * Computes reservoir depletion and gain excursion during channel add/drop:
 *   - Average carrier lifetime tau_EDFA ~ 10 ms
 *   - Surviving channel power excursion Delta P_surv(t)
 *   - Optical AGC feedback loop stabilization time (< 15 microseconds)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: EdfaTransientResult = {
    peakExcursionDb    :: !Real,        // Peak overshoot or undershoot in dB
    settlingTimeUs     :: !Real,        // AGC loop settling duration
    survivingChannelsCount:: !Int,
    droppedChannelsCount  :: !Int
}

evaluateGainExcursion :: !Int !Int !Real -> EdfaTransientResult

implementation module Etalon.Simulation.AvailabilityMonteCarlo

/*
 * AvailabilityMonteCarlo.icl: Markov availability implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.AvailabilityMonteCarlo
import Etalon.Types.Base

simulateAnnualAvailability :: !Real !Real !Int -> NetworkAvailabilityReport
simulateAnnualAvailability linkMtbfHours mttrHours numSpans =
    let totalSpanHours = toReal numSpans * (8760.0 / linkMtbfHours)
        annualDownHours = totalSpanHours * mttrHours * 0.05 // protected path factor
        downMins = annualDownHours * 60.0
        nines = 5.0 - (downMins / 52.6) * 0.5
    in {
        annualDowntimeMinutes = downMins,
        achievedNines         = maxReal 4.0 (minReal 5.5 nines),
        totalOutageEvents     = toInt (ceil totalSpanHours)
    }

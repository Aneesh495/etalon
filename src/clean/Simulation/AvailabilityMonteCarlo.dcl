definition module Etalon.Simulation.AvailabilityMonteCarlo

/*
 * AvailabilityMonteCarlo.dcl: Markov state network availability simulator.
 *
 * Runs year-long continuous time Markov chain (CTMC) simulations:
 *   - Fiber cable MTBF ~ 100,000 hours per 100 km
 *   - Mean Time to Repair MTTR ~ 8 to 24 hours
 *   - Annual system downtime in minutes and SLA penalties
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: NetworkAvailabilityReport = {
    annualDowntimeMinutes:: !Real,
    achievedNines        :: !Real,
    totalOutageEvents    :: !Int
}

simulateAnnualAvailability :: !Real !Real !Int -> NetworkAvailabilityReport

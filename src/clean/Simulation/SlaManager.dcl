definition module Etalon.Simulation.SlaManager

/*
 * SlaManager.dcl: 99.999% SLA availability and downtime credit accounting.
 *
 * Tracks annual carrier availability targets:
 *   - 5 Nines (99.999%): at most 5.26 minutes downtime per year
 *   - 4 Nines (99.99%): at most 52.6 minutes downtime per year
 *   - Mean Time Between Failures (MTBF) and Mean Time to Repair (MTTR)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: SlaRecord = {
    serviceId          :: !Int,
    targetAvailabilityPercent:: !Real,
    totalUptimeSeconds :: !Real,
    totalDowntimeSeconds:: !Real
}

computeMeasuredAvailability:: !SlaRecord -> Real
isSlaCompliant            :: !SlaRecord -> Bool

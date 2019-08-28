implementation module Etalon.Simulation.SlaManager

/*
 * SlaManager.icl: SLA manager implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.SlaManager
import Etalon.Types.Base

computeMeasuredAvailability :: !SlaRecord -> Real
computeMeasuredAvailability rec =
    let total = rec.totalUptimeSeconds + rec.totalDowntimeSeconds
    in if (total <= 0.0) 100.0 ((rec.totalUptimeSeconds / total) * 100.0)

isSlaCompliant :: !SlaRecord -> Bool
isSlaCompliant rec =
    let actual = computeMeasuredAvailability rec
    in actual >= rec.targetAvailabilityPercent

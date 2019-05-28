implementation module Etalon.Simulation.Metrics

/*
 * Metrics.icl: Implementation of optical KPIs and performance metrics.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path
import Etalon.Topology.NetworkState
import Etalon.Protection.FaultManager
import Etalon.Simulation.Metrics

computeCarriedCapacityTbps :: !WorldState -> Real
computeCarriedCapacityTbps state =
    let totalGbps = sum [lp.clientBitrateGbps \\ lp <- state.activeLightpaths | lp.isActive]
    in totalGbps * 1.0e-3

computeAverageOsnrDb :: !WorldState -> Real
computeAverageOsnrDb state
    | isEmpty state.activeLightpaths = 0.0
    = let sumOsnr = sum [lp.operatingOsnrDb \\ lp <- state.activeLightpaths]
          count = toReal (length state.activeLightpaths)
      in sumOsnr / count

computeMeanTimeToRestoreUs :: ![FailoverReport] -> Real
computeMeanTimeToRestoreUs reports
    | isEmpty reports = 0.0
    = let totalLatency = sum [r.restorationLatencyUs \\ r <- reports]
          count = toReal (length reports)
      in totalLatency / count

computeKpiDashboard :: !WorldState ![FailoverReport] -> OpticalKpiDashboard
computeKpiDashboard state reports =
    let carried = computeCarriedCapacityTbps state
        util = computeNetworkUtilization state
        avgOsnr = computeAverageOsnrDb state
        mttr = computeMeanTimeToRestoreUs reports
        sub50msCount = sum [1 \\ r <- reports | r.restorationLatencyUs <= 50000.0 && r.isRestored]
        totalReps = length reports
        sub50msRate = if (totalReps == 0) 1.0 ((toReal sub50msCount) / (toReal totalReps))
        worstLatency = if (totalReps == 0) 0.0 (foldl maxReal 0.0 [r.restorationLatencyUs \\ r <- reports])
    in {
        totalCarriedCapacityTbps = carried,
        networkWideUtilization   = util,
        averageLightpathOsnrDb   = avgOsnr,
        sub50msRestorationRate   = sub50msRate,
        worstCaseFailoverUs      = worstLatency,
        activeAlarmCount         = 0
    }

formatDashboardSummary :: !OpticalKpiDashboard -> String
formatDashboardSummary d =
    "Capacity: " +++ (toString d.totalCarriedCapacityTbps) +++ " Tbps, " +++
    "Util: " +++ (toString (d.networkWideUtilization * 100.0)) +++ "%, " +++
    "Sub-50ms Rate: " +++ (toString (d.sub50msRestorationRate * 100.0)) +++ "%"

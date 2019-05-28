definition module Etalon.Simulation.Metrics

/*
 * Metrics.dcl: Carrier-Grade Optical Performance and Quality Metrics.
 *
 * Computes:
 *   - Bandwidth Blocking Ratio (BBR)
 *   - Connection Blocking Probability (CBP)
 *   - Mean Time to Restore (MTTR) under fiber cuts
 *   - Global Spectrum Utilization and Shannon Entropy
 *   - Average End-to-End OSNR and FEC Margin Distribution
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.NetworkState
import Etalon.Protection.FaultManager

:: OpticalKpiDashboard = {
    totalCarriedCapacityTbps :: !Real,
    networkWideUtilization   :: !Real,
    averageLightpathOsnrDb   :: !Real,
    sub50msRestorationRate   :: !Real,
    worstCaseFailoverUs      :: !Real,
    activeAlarmCount         :: !Int
}

// KPI and analytics calculations
computeKpiDashboard    :: !WorldState ![FailoverReport] -> OpticalKpiDashboard
computeMeanTimeToRestoreUs :: ![FailoverReport] -> Real
computeCarriedCapacityTbps :: !WorldState -> Real
computeAverageOsnrDb   :: !WorldState -> Real
formatDashboardSummary :: !OpticalKpiDashboard -> String

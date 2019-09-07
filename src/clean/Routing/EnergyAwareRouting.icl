implementation module Etalon.Routing.EnergyAwareRouting

/*
 * EnergyAwareRouting.icl: Energy aware routing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.EnergyAwareRouting
import Etalon.Types.Base
import Etalon.Topology.NetworkState

computeTotalNetworkPowerWatts :: !WorldState -> Real
computeTotalNetworkPowerWatts state =
    let activeTranspondersWatts = toReal (length state.activeLightpaths) * 250.0 // 250W per coherent transponder
        activeLinksWatts = toReal (length state.linkSpectrums) * 80.0          // 80W per line amplifier site
    in activeTranspondersWatts + activeLinksWatts

evaluatePowerSavingsRatio :: !Real !Real -> Real
evaluatePowerSavingsRatio baselineWatts optimizedWatts =
    if (baselineWatts <= 0.0) 0.0 ((baselineWatts - optimizedWatts) / baselineWatts)

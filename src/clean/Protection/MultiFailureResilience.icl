implementation module Etalon.Protection.MultiFailureResilience

/*
 * MultiFailureResilience.icl: Multi-failure resilience implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.MultiFailureResilience
import Etalon.Types.Base
import Etalon.Topology.NetworkState

prioritizeRestoration :: ![PrioritizedService] -> [PrioritizedService]
prioritizeRestoration services =
    // Sort services: Gold first, Silver second, Bronze preempted last
    let golds = [s \ s <- services | isGold s.tier]
        silvers = [s \ s <- services | isSilver s.tier]
        bronzes = [{ s & isPreempted = True } \ s <- services | isBronze s.tier]
    in golds ++ silvers ++ bronzes
where
    isGold TierGoldPremium = True
    isGold _ = False

    isSilver TierSilverStandard = True
    isSilver _ = False

    isBronze TierBronzeBestEffort = True
    isBronze _ = False

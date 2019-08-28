implementation module Etalon.Simulation.ErlangTrafficEngine

/*
 * ErlangTrafficEngine.icl: Erlang engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.ErlangTrafficEngine
import Etalon.Types.Base

computeErlangB :: !Real !Int -> Real
computeErlangB offeredLoadErlangs channelsCount =
    // Iterative stable recurrence: B_k = (E * B_{k-1}) / (k + E * B_{k-1}) with B_0 = 1.0
    erlangRecurse 1.0 1
where
    erlangRecurse :: !Real !Int -> Real
    erlangRecurse b k
        | k > channelsCount = b
        = let nextB = (offeredLoadErlangs * b) / (toReal k + offeredLoadErlangs * b)
          in erlangRecurse nextB (k + 1)

computeErlangC :: !Real !Int -> Real
computeErlangC offeredLoad channels =
    let b = computeErlangB offeredLoad channels
        cNum = b
        cDen = 1.0 - (offeredLoad / toReal channels) * (1.0 - b)
    in if (cDen <= 0.0) 1.0 (minReal 1.0 (cNum / cDen))

implementation module Etalon.Topology.OpticalLinkBudget

/*
 * OpticalLinkBudget.icl: Link budget accountant implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.OpticalLinkBudget
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeSpanLossBudget :: !FiberSpan !Int -> OpticalLossBudget
computeSpanLossBudget span numSplices =
    let bulkLoss = span.fiberType.attenuationDbPerKm * span.lengthKm
        splices = toReal numSplices * 0.05
        connectors = 0.70 // 2 connectors @ 0.35 dB
        safety = 2.00     // 2.0 dB aging margin
        tot = bulkLoss + splices + connectors + safety
    in {
        fiberBulkLossDb = bulkLoss,
        spliceLossDb    = splices,
        connectorLossDb = connectors,
        safetyMarginDb  = safety,
        totalSpanLossDb = tot
    }

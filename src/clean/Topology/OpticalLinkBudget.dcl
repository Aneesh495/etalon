definition module Etalon.Topology.OpticalLinkBudget

/*
 * OpticalLinkBudget.dcl: Comprehensive optical span link budget accountant.
 *
 * Details complete link loss ledger:
 *   - Fiber bulk attenuation: L * alpha
 *   - Fusion splice loss: N_splices * 0.05 dB
 *   - Connector insertion loss: 2 * 0.35 dB
 *   - Unallocated design margin (2.0 dB)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: OpticalLossBudget = {
    fiberBulkLossDb    :: !Real,
    spliceLossDb       :: !Real,
    connectorLossDb    :: !Real,
    safetyMarginDb     :: !Real,
    totalSpanLossDb    :: !Real
}

computeSpanLossBudget  :: !FiberSpan !Int -> OpticalLossBudget

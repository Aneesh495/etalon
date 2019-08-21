definition module Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

/*
 * SharedRiskLinkGroupCorrelatedCuts.dcl: Multi-layer SRLG conduit risk and bridge crossing cuts.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SrlgConduit =
    { conduitId    :: !Int
    , fiberLinkIds :: ![Int]
    , isBridgeCrossing :: !Bool
    }

doesSpanShareConduit :: !SrlgConduit !Int !Int -> Bool

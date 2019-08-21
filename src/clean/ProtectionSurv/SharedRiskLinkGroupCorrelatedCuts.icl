implementation module Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

/*
 * SharedRiskLinkGroupCorrelatedCuts.icl: SRLG conduit implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

doesSpanShareConduit :: !SrlgConduit !Int !Int -> Bool
doesSpanShareConduit conduit l1 l2 =
    isMember l1 conduit.fiberLinkIds && isMember l2 conduit.fiberLinkIds

isMember :: !Int ![Int] -> Bool
isMember _ [] = False
isMember target [x:xs] = (x == target) || isMember target xs

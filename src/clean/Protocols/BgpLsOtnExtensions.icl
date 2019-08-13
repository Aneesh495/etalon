implementation module Etalon.Protocols.BgpLsOtnExtensions

/*
 * BgpLsOtnExtensions.icl: BGP-LS Optical TE encoding implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.BgpLsOtnExtensions

createBgpLsLink :: !Int !Int !Int !Int ![Int] !Real !Real -> BgpLsOpticalLink
createBgpLsLink lId locId remId metric srlgs totalBw unresBw =
    { linkIdentifier     = lId
    , localRouterId      = locId
    , remoteRouterId     = remId
    , teMetric           = metric
    , srlgList           = srlgs
    , totalBandwidthGbps = totalBw
    , unreservedGbps     = unresBw
    }

formatBgpLsUpdate :: !BgpLsOpticalLink !Int !Bool -> BgpLsUpdateMessage
formatBgpLsUpdate link asNum withdrawn =
    { asNumber       = asNum
    , linkDescriptor = link
    , isWithdrawn    = withdrawn
    }

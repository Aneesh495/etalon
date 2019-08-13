definition module Etalon.Protocols.BgpLsOptical

/*
 * BgpLsOptical.dcl: BGP-LS optical link-state extensions (RFC 7752 / RFC 9093).
 *
 * Encodes optical link attributes for SDN northbound path computation:
 *   - Maximum reservable bandwidth
 *   - Unreserved flexible grid spectrum slices
 *   - Physical optical impairment metrics (CD, PMD, OSNR penalty)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: BgpLsLinkNlri = {
    protocolId         :: !Int,        // 1 = IS-IS, 2 = OSPF-TE
    localRouterId      :: !String,
    remoteRouterId     :: !String,
    availableBandwidthGbps:: !Real,
    opticalMarginDb    :: !Real
}

formatBgpLsTlvSummary :: !BgpLsLinkNlri -> String

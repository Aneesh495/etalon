implementation module Etalon.Protocols.BgpLsOptical

/*
 * BgpLsOptical.icl: BGP-LS optical implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.BgpLsOptical
import Etalon.Types.Base

formatBgpLsTlvSummary :: !BgpLsLinkNlri -> String
formatBgpLsTlvSummary nlri =
    "BGP-LS(" +++ nlri.localRouterId +++ "->" +++ nlri.remoteRouterId +++ ",BW=" +++ toString nlri.availableBandwidthGbps +++ "G)"

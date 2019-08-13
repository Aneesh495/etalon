definition module Etalon.Protocols.BgpLsOtnExtensions

/*
 * BgpLsOtnExtensions.dcl: BGP-LS Link-State NLRI encoding for Optical TE Links.
 * Compliant with RFC 7752 and draft-ietf-idr-te-lsp-distribution.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: BgpLsOpticalLink =
    { linkIdentifier  :: !Int
    , localRouterId   :: !Int
    , remoteRouterId  :: !Int
    , teMetric        :: !Int
    , srlgList        :: ![Int]
    , totalBandwidthGbps :: !Real
    , unreservedGbps  :: !Real
    }

:: BgpLsUpdateMessage =
    { asNumber       :: !Int
    , linkDescriptor :: !BgpLsOpticalLink
    , isWithdrawn    :: !Bool
    }

createBgpLsLink :: !Int !Int !Int !Int ![Int] !Real !Real -> BgpLsOpticalLink
formatBgpLsUpdate :: !BgpLsOpticalLink !Int !Bool -> BgpLsUpdateMessage

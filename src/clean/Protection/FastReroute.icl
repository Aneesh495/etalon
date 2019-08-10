implementation module Etalon.Protection.FastReroute

/*
 * FastReroute.icl: Fast reroute implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.FastReroute
import Etalon.Types.Base
import Etalon.Topology.Path

createFrrBypassTunnel :: !Int !Int !Int !OpticalRoute -> FrrBypassTunnel
createFrrBypassTunnel pLink plr mp route = {
    protectedLinkId = pLink,
    plrNodeId       = plr,
    mpNodeId        = mp,
    bypassRoute     = route
 }

definition module Etalon.Protection.FastReroute

/*
 * FastReroute.dcl: Optical Fast Reroute (FRR) local repair.
 *
 * Pre-computes bypass tunnels around vulnerable spans for immediate switch:
 *   - Point of Local Repair (PLR) switchover
 *   - Merge Point (MP) optical realignment
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: FrrBypassTunnel = {
    protectedLinkId    :: !Int,
    plrNodeId          :: !Int,
    mpNodeId           :: !Int,
    bypassRoute        :: !OpticalRoute
}

createFrrBypassTunnel :: !Int !Int !Int !OpticalRoute -> FrrBypassTunnel

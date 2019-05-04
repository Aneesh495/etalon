definition module Etalon.Routing.Regenerator

/*
 * Regenerator.dcl: 3R Electrical Regenerator Placement Optimization.
 *
 * Optimizes the placement of 3R (Re-amplification, Reshaping, Retiming) electrical regenerators
 * along ultra-long-haul transcontinental and subsea optical routes when physical reach limits
 * or maximum acceptable pre-FEC Bit Error Rates are exceeded.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Topology.Path
import Etalon.Topology.Graph

:: RegeneratorSite = {
    nodeId             :: !Int,
    transponderCount   :: !Int,
    availableCards     :: !Int
}

:: RegeneratedLightpath = {
    originalPathId     :: !Int,
    subRoutes          :: ![OpticalRoute],
    regeneratorNodes   :: ![Int],
    totalRegenerators  :: !Int,
    overallFeasible    :: !Bool
}

// Regenerator placement algorithms
needsRegeneration      :: !OpticalRoute !ModulationFormat -> Bool
computeMaxReachForMod  :: !ModulationFormat -> Real
findRegeneratorSites   :: !OpticalGraph !OpticalRoute !ModulationFormat -> [Int]
partitionRouteWithRegenerators :: !OpticalGraph !OpticalRoute !ModulationFormat -> RegeneratedLightpath

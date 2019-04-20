definition module Etalon.Topology.NetworkState

/*
 * NetworkState.dcl: Global Optical Transport Network World State.
 *
 * Encapsulates the entire optical plane state including:
 *   - Physical graph topology (nodes, fiber links)
 *   - Per-link flexible grid spectrum bitmaps (*SpectrumBitmap)
 *   - Per-ROADM WSS cross-connect matrices (*CrossConnectMatrix)
 *   - Active provisioned lightpaths
 *   - Active alarms and defect tables
 *
 * Uses uniqueness typing (*WorldState) to guarantee safe in-place state transitions.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topology.Path
import Etalon.Topology.CrossConnect

:: LinkSpectrumState = {
    linkRefId          :: !Int,
    spectrum           :: !SpectrumBitmap
}

:: *WorldState = {
    topology           :: !OpticalGraph,
    linkSpectrums      :: ![LinkSpectrumState],
    crossConnects      :: ![CrossConnectMatrix],
    activeLightpaths   :: ![Lightpath],
    nextServiceId      :: !Int
}

// Lifecycle and constructors
initWorldState         :: !OpticalGraph -> *WorldState

// Spectrum management across links
isSpectrumAvailableOnRoute :: !WorldState !OpticalRoute !Int !Int -> Bool
reserveRouteSpectrum   :: !*WorldState !OpticalRoute !Int !Int -> *WorldState
releaseRouteSpectrum   :: !*WorldState !OpticalRoute !Int !Int -> *WorldState

// Lightpath provisioning
provisionLightpath     :: !*WorldState !Lightpath -> *WorldState
teardownLightpath      :: !*WorldState !Int -> *WorldState
findLightpathById      :: !WorldState !Int -> Lightpath

// Network health and utilization
computeNetworkUtilization :: !WorldState -> Real
countTotalProvisionedServices :: !WorldState -> Int

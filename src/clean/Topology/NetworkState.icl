implementation module Etalon.Topology.NetworkState

/*
 * NetworkState.icl: Implementation of the global optical network world state.
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
import Etalon.Topology.NetworkState

initWorldState :: !OpticalGraph -> *WorldState
initWorldState g =
    let linkSpecs = [{ linkRefId = l.linkId, spectrum = initSpectrumBitmap totalSlices } \\ l <- g.links]
        xcs = [createCrossConnectMatrix n.nodeId \\ n <- g.nodes]
    in {
        topology         = g,
        linkSpectrums    = linkSpecs,
        crossConnects    = xcs,
        activeLightpaths = [],
        nextServiceId    = 1
    }

isSpectrumAvailableOnRoute :: !WorldState !OpticalRoute !Int !Int -> Bool
isSpectrumAvailableOnRoute state route start len =
    all (\lId -> checkLinkSpectrum state.linkSpectrums lId start len) route.linkSequence
where
    checkLinkSpectrum :: ![LinkSpectrumState] !Int !Int !Int -> Bool
    checkLinkSpectrum [] _ _ _ = False
    checkLinkSpectrum [ls:rest] targetId s l
        | ls.linkRefId == targetId = isRangeFree ls.spectrum s l
        = checkLinkSpectrum rest targetId s l

reserveRouteSpectrum :: !*WorldState !OpticalRoute !Int !Int -> *WorldState
reserveRouteSpectrum state=:{linkSpectrums} route start len =
    let updatedSpecs = [{ ls & spectrum = if (isMember ls.linkRefId route.linkSequence)
                                            (allocateSliceRange ls.spectrum start len)
                                            ls.spectrum } \\ ls <- linkSpectrums]
    in { state & linkSpectrums = updatedSpecs }

releaseRouteSpectrum :: !*WorldState !OpticalRoute !Int !Int -> *WorldState
releaseRouteSpectrum state=:{linkSpectrums} route start len =
    let updatedSpecs = [{ ls & spectrum = if (isMember ls.linkRefId route.linkSequence)
                                            (releaseSliceRange ls.spectrum start len)
                                            ls.spectrum } \\ ls <- linkSpectrums]
    in { state & linkSpectrums = updatedSpecs }

provisionLightpath :: !*WorldState !Lightpath -> *WorldState
provisionLightpath state=:{activeLightpaths,nextServiceId} lp =
    let s1 = reserveRouteSpectrum state lp.route lp.allocatedSlot.startSlice lp.allocatedSlot.sliceCount
    in { s1 & activeLightpaths = activeLightpaths ++ [lp], nextServiceId = nextServiceId + 1 }

teardownLightpath :: !*WorldState !Int -> *WorldState
teardownLightpath state=:{activeLightpaths} targetPathId =
    let target = searchLp activeLightpaths
    in case target of
        Nothing -> state
        Just lp ->
            let s1 = releaseRouteSpectrum state lp.route lp.allocatedSlot.startSlice lp.allocatedSlot.sliceCount
                remaining = [p \\ p <- activeLightpaths | p.pathId <> targetPathId]
            in { s1 & activeLightpaths = remaining }
where
    searchLp :: ![Lightpath] -> ?Lightpath
    searchLp [] = ?None
    searchLp [p:ps]
        | p.pathId == targetPathId = ?Just p
        = searchLp ps

findLightpathById :: !WorldState !Int -> Lightpath
findLightpathById state targetId =
    searchLps state.activeLightpaths
where
    searchLps [] = createLightpath 0 0 (createRouteFromLinks 0 []) (createFrequencySlot 0 4) DpQpsk FecHd7Percent 100.0
    searchLps [p:ps]
        | p.pathId == targetId = p
        = searchLps ps

computeNetworkUtilization :: !WorldState -> Real
computeNetworkUtilization state
    | isEmpty state.linkSpectrums = 0.0
    = let totalAlloc = sum [(totalSlices - ls.spectrum.freeSliceCount) \\ ls <- state.linkSpectrums]
          totalCap = (length state.linkSpectrums) * totalSlices
      in (toReal totalAlloc) / (toReal totalCap)

countTotalProvisionedServices :: !WorldState -> Int
countTotalProvisionedServices state = length state.activeLightpaths

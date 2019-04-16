implementation module Etalon.Topology.Path

/*
 * Path.icl: Implementation of optical route construction and disjointness validation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.Spectrum
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Topology.Graph
import Etalon.Topology.Path

computeRouteDelayMs :: !Real -> Real
computeRouteDelayMs lengthKm =
    // Speed of light in silica fiber: c / n_g approx 200,000 km/s (5 us / km)
    let speedInFiberKmPerSec = 200000.0
    in (lengthKm / speedInFiberKmPerSec) * 1000.0

createRouteFromLinks :: !Int ![OpticalLink] -> OpticalRoute
createRouteFromLinks rId links =
    let totalLen = sum [l.totalDistanceKm \\ l <- links]
        delay = computeRouteDelayMs totalLen
        nodes = extractNodes links
        linkIds = [l.linkId \\ l <- links]
        allSrlg = removeDup (flatten [l.srlgList \\ l <- links])
    in {
        routeId                 = rId,
        nodeSequence            = nodes,
        linkSequence            = linkIds,
        totalLengthKm           = totalLen,
        totalPropagationDelayMs = delay,
        srlgUnion               = allSrlg
    }
where
    extractNodes :: ![OpticalLink] -> [Int]
    extractNodes [] = []
    extractNodes [firstLink:rest] =
        [firstLink.sourceNodeId : [l.targetNodeId \\ l <- [firstLink:rest]]]

areRoutesSrlgDisjoint :: !OpticalRoute !OpticalRoute -> Bool
areRoutesSrlgDisjoint r1 r2 =
    let shared = [s \\ s <- r1.srlgUnion | isMember s r2.srlgUnion]
    in isEmpty shared

areRoutesNodeDisjoint :: !OpticalRoute !OpticalRoute -> Bool
areRoutesNodeDisjoint r1 r2 =
    // Intermediate nodes must be disjoint (excluding source and destination endpoints)
    let inter1 = intermediateNodes r1.nodeSequence
        inter2 = intermediateNodes r2.nodeSequence
        shared = [n \\ n <- inter1 | isMember n inter2]
    in isEmpty shared
where
    intermediateNodes :: ![Int] -> [Int]
    intermediateNodes [] = []
    intermediateNodes [_] = []
    intermediateNodes [_, _] = []
    intermediateNodes [_:ns] = init ns

createLightpath :: !Int !Int !OpticalRoute !FrequencySlot !ModulationFormat !FecType !Real -> Lightpath
createLightpath pId sId r slot mod fec bitrate = {
    pathId            = pId,
    serviceId         = sId,
    route             = r,
    allocatedSlot     = slot,
    modulation        = mod,
    fec               = fec,
    clientBitrateGbps = bitrate,
    operatingOsnrDb   = 25.0,
    isProtected       = False,
    isActive          = True
}

activateLightpath :: !Lightpath -> Lightpath
activateLightpath lp = { lp & isActive = True }

deactivateLightpath :: !Lightpath -> Lightpath
deactivateLightpath lp = { lp & isActive = False }

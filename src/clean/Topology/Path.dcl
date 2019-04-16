definition module Etalon.Topology.Path

/*
 * Path.dcl: Optical Lightpath and Route Representation.
 *
 * Represents an end-to-end transparent optical lightpath traversing multiple ROADM nodes,
 * fiber spans, and optical amplifier cascades.
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

:: OpticalRoute = {
    routeId            :: !Int,
    nodeSequence       :: ![Int],         // Ordered sequence of node IDs [src, n1, n2, ..., dst]
    linkSequence       :: ![Int],         // Sequence of link IDs
    totalLengthKm      :: !Real,
    totalPropagationDelayMs :: !Real,
    srlgUnion          :: ![Int]          // Combined SRLG set for disjointness checks
}

:: Lightpath = {
    pathId             :: !Int,
    serviceId          :: !Int,
    route              :: !OpticalRoute,
    allocatedSlot      :: !FrequencySlot,
    modulation         :: !ModulationFormat,
    fec                :: !FecType,
    clientBitrateGbps  :: !Real,
    operatingOsnrDb    :: !Real,
    isProtected        :: !Bool,
    isActive           :: !Bool
}

// Route constructors and metrics
createRouteFromLinks   :: !Int ![OpticalLink] -> OpticalRoute
areRoutesSrlgDisjoint  :: !OpticalRoute !OpticalRoute -> Bool
areRoutesNodeDisjoint  :: !OpticalRoute !OpticalRoute -> Bool
computeRouteDelayMs    :: !Real -> Real

// Lightpath lifecycle
createLightpath        :: !Int !Int !OpticalRoute !FrequencySlot !ModulationFormat !FecType !Real -> Lightpath
activateLightpath      :: !Lightpath -> Lightpath
deactivateLightpath    :: !Lightpath -> Lightpath

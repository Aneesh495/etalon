definition module Etalon.Physical.Roadm

/*
 * Roadm.dcl: Reconfigurable Optical Add-Drop Multiplexer (ROADM) node architecture.
 *
 * Implements Colorless, Directionless, Contentionless (CDC) ROADM switching nodes
 * with Wavelength Selective Switch (WSS) insertion loss and per-slice attenuation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Types.Spectrum

:: RoadmArchitecture =
    CdcRoadm          // Colorless, Directionless, Contentionless ROADM
  | BroadcastAndSelect // Splitter-and-select architecture
  | RouteAndSelect    // Dual-WSS route-and-select architecture

:: RoadmPort = {
    portId             :: !Int,
    portDegree         :: !Int,
    isLinePort         :: !Bool,
    isAddDrop          :: !Bool,
    insertionLossDb    :: !Real
}

:: RoadmNode = {
    nodeId             :: !Int,
    nodeName           :: !String,
    architecture       :: !RoadmArchitecture,
    degreeCount        :: !Int,
    addDropCapacity    :: !Int,
    wssPassLossDb      :: !Real,
    ports              :: ![RoadmPort]
}

// Node constructors
createCdcRoadmNode     :: !Int !String !Int !Int -> RoadmNode
createStandardRoadm    :: !Int !String !Int -> RoadmNode

// Insertion loss queries
computeExpressLossDb   :: !RoadmNode !Int !Int -> Real
computeAddLossDb       :: !RoadmNode !Int -> Real
computeDropLossDb      :: !RoadmNode !Int -> Real

// Optical switching pass
passChannelThroughRoadm :: !RoadmNode !Int !Int !OpticalChannel -> OpticalChannel
architectureToString   :: !RoadmArchitecture -> String

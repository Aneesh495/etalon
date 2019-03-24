implementation module Etalon.Physical.Roadm

/*
 * Roadm.icl: Implementation of ROADM node structures and optical pass attenuation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Types.Spectrum
import Etalon.Physical.Roadm

createCdcRoadmNode :: !Int !String !Int !Int -> RoadmNode
createCdcRoadmNode nId name degrees addDropCap =
    let linePorts = [{ portId = d, portDegree = d, isLinePort = True, isAddDrop = False, insertionLossDb = 6.5 } \\ d <- [1..degrees]]
        adPorts = [{ portId = degrees + k, portDegree = 0, isLinePort = False, isAddDrop = True, insertionLossDb = 12.0 } \\ k <- [1..addDropCap]]
    in {
        nodeId          = nId,
        nodeName        = name,
        architecture    = CdcRoadm,
        degreeCount     = degrees,
        addDropCapacity = addDropCap,
        wssPassLossDb   = 6.5,
        ports           = linePorts ++ adPorts
    }

createStandardRoadm :: !Int !String !Int -> RoadmNode
createStandardRoadm nId name degrees = createCdcRoadmNode nId name degrees 16

computeExpressLossDb :: !RoadmNode !Int !Int -> Real
computeExpressLossDb node inDegree outDegree
    | inDegree == outDegree = 0.0 // Loopback not supported
    = case node.architecture of
        RouteAndSelect     -> node.wssPassLossDb * 2.0 // Ingress WSS + Egress WSS
        BroadcastAndSelect -> node.wssPassLossDb + 9.0 // Splitter loss + Select WSS
        CdcRoadm           -> node.wssPassLossDb + 2.0 // Non-blocking cross-connect matrix

computeAddLossDb :: !RoadmNode !Int -> Real
computeAddLossDb node portId =
    case node.architecture of
        CdcRoadm -> 14.0 // Transponder aggregator (TPA) + WSS multiplexer
        _        -> 10.0

computeDropLossDb :: !RoadmNode !Int -> Real
computeDropLossDb node portId =
    case node.architecture of
        CdcRoadm -> 14.0 // WSS demultiplexer + multicast switch (MCS)
        _        -> 10.0

passChannelThroughRoadm :: !RoadmNode !Int !Int !OpticalChannel -> OpticalChannel
passChannelThroughRoadm node inPort outPort ch =
    let lossDb = if (inPort == 0)
                    (computeAddLossDb node outPort)
                    (if (outPort == 0)
                        (computeDropLossDb node inPort)
                        (computeExpressLossDb node inPort outPort))
        lossLinear = dbToLinear lossDb
        newPowerW = ch.signalPowerWatts / lossLinear
    in updateSignalPower ch newPowerW

architectureToString :: !RoadmArchitecture -> String
architectureToString CdcRoadm           = "Colorless-Directionless-Contentionless (CDC)"
architectureToString BroadcastAndSelect = "Broadcast-and-Select (Splitter/WSS)"
architectureToString RouteAndSelect     = "Route-and-Select (Dual WSS)"

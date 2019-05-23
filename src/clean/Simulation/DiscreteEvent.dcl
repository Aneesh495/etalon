definition module Etalon.Simulation.DiscreteEvent

/*
 * DiscreteEvent.dcl: Discrete Event Simulation Engine for Optical Networks.
 *
 * Simulates dynamic lightpath arrivals and departures, tracking blocking probabilities,
 * spectrum utilization, and load curves over extended simulation horizons.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.NetworkState
import Etalon.Routing.ImpairmentAware
import Etalon.Routing.SpectrumAssign
import Etalon.Simulation.TrafficGenerator

:: SimulationEvent = {
    eventTime          :: !Real,
    isArrival          :: !Bool,
    demandPayload      :: !ServiceDemand,
    teardownPathId     :: !Int
}

:: SimulationMetrics = {
    totalOfferedDemands :: !Int,
    acceptedDemands     :: !Int,
    blockedDemands      :: !Int,
    blockingRatio       :: !Real,
    totalOfferedGbps    :: !Real,
    acceptedGbps        :: !Real,
    averageHoldTime     :: !Real
}

:: *SimulationState = {
    networkState       :: !WorldState,
    eventQueue         :: ![SimulationEvent],
    currentTime        :: !Real,
    metrics            :: !SimulationMetrics
}

// Simulation lifecycle
initSimulationState    :: !WorldState -> *SimulationState
enqueueEvent           :: !*SimulationState !SimulationEvent -> *SimulationState
runSimulationUntilTime :: !*SimulationState !Real !AllocationPolicy -> (*SimulationState, SimulationMetrics)
formatMetricsReport    :: !SimulationMetrics -> String

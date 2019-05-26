definition module Etalon.Simulation.FiberCut

/*
 * FiberCut.dcl: Physical Fiber Cut and Degradation Scenario Generator.
 *
 * Models catastrophic physical fiber cuts, backhoe incidents, amplifier pump failures,
 * and optical transient power surges following sudden channel drop events.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.NetworkState
import Etalon.Protection.FaultManager

:: FiberCutScenario = {
    scenarioId         :: !Int,
    scenarioName       :: !String,
    severedLinkIds     :: ![Int],
    affectedSrlgs      :: ![Int],
    surgeExcursionDb   :: !Real,          // Optical surge overshoot in surviving channels (dB)
    cutDurationSeconds :: !Real
}

// Scenario constructors and simulation
createSingleCutScenario :: !Int !Int -> FiberCutScenario
createDoubleCutScenario :: !Int !Int !Int -> FiberCutScenario
createSrlgCutScenario   :: !Int !Int ![Int] -> FiberCutScenario

// Simulation execution
simulateCutEvent       :: !*WorldState !FiberCutScenario -> (*WorldState, [FailoverReport])
computeTransientSurgeDb :: !Int !Int -> Real

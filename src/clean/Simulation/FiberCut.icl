implementation module Etalon.Simulation.FiberCut

/*
 * FiberCut.icl: Implementation of fiber cut scenarios and transient surge analysis.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.NetworkState
import Etalon.Protection.FaultManager
import Etalon.Simulation.FiberCut

computeTransientSurgeDb :: !Int !Int -> Real
computeTransientSurgeDb totalChannels droppedChannels
    | totalChannels <= 0 || droppedChannels <= 0 = 0.0
    | droppedChannels >= totalChannels           = 0.0
    = let surviving = totalChannels - droppedChannels
          ratio = (toReal totalChannels) / (toReal surviving)
      in linearToDb ratio

createSingleCutScenario :: !Int !Int -> FiberCutScenario
createSingleCutScenario sId lId = {
    scenarioId         = sId,
    scenarioName       = "Single Fiber Cut on Link " +++ (toString lId),
    severedLinkIds     = [lId],
    affectedSrlgs      = [],
    surgeExcursionDb   = computeTransientSurgeDb 80 40,
    cutDurationSeconds = 14400.0 // 4 hours repair time
}

createDoubleCutScenario :: !Int !Int !Int -> FiberCutScenario
createDoubleCutScenario sId l1 l2 = {
    scenarioId         = sId,
    scenarioName       = "Dual Simultaneous Fiber Cut",
    severedLinkIds     = [l1, l2],
    affectedSrlgs      = [],
    surgeExcursionDb   = computeTransientSurgeDb 80 60,
    cutDurationSeconds = 28800.0
}

createSrlgCutScenario :: !Int !Int ![Int] -> FiberCutScenario
createSrlgCutScenario sId srlg links = {
    scenarioId         = sId,
    scenarioName       = "Catastrophic SRLG Conduit Cut",
    severedLinkIds     = links,
    affectedSrlgs      = [srlg],
    surgeExcursionDb   = computeTransientSurgeDb 80 70,
    cutDurationSeconds = 43200.0
}

simulateCutEvent :: !*WorldState !FiberCutScenario -> (*WorldState, [FailoverReport])
simulateCutEvent state scenario =
    applyCuts state scenario.severedLinkIds []
where
    applyCuts :: !*WorldState ![Int] ![FailoverReport] -> (*WorldState, [FailoverReport])
    applyCuts curState [] acc = (curState, reverse acc)
    applyCuts curState [lId:ls] acc =
        let (sNext, reps) = processFiberCut curState lId 1000
        in applyCuts sNext ls (reps ++ acc)

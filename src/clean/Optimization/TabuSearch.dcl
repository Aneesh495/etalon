definition module Etalon.Optimization.TabuSearch

/*
 * TabuSearch.dcl: Adaptive tabu tenure wavelength retuning engine.
 *
 * Implements tabu search with recency and frequency memory structures:
 *   - Tabu list prevents cycling on recently shifted optical lightpaths
 *   - Aspiration criterion overrides tabu status if global lowest fragmentation reached
 *   - Diversification mechanism drives search into unexplored spectrum regions
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

:: TabuMove = {
    lightpathId  :: !Int,
    oldStartSlice:: !Int,
    newStartSlice:: !Int,
    tenureRemaining:: !Int
}

:: TabuConfig = {
    baseTenure       :: !Int,          // Base tabu duration (e.g., 7 iterations)
    maxIterations    :: !Int,          // Total search budget
    neighborhoodSize :: !Int           // Number of candidate retuning moves per step
}

:: TabuSearchResult = {
    bestScore        :: !Real,
    iterationsRun    :: !Int,
    tabuHitsPrevented:: !Int,
    aspirationsUsed  :: !Int
}

defaultTabuConfig    :: TabuConfig
runTabuSearchOptimizer:: !*WorldState !TabuConfig -> (*WorldState, TabuSearchResult)

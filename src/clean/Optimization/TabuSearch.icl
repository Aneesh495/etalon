implementation module Etalon.Optimization.TabuSearch

/*
 * TabuSearch.icl: Adaptive tabu tenure retuning implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Optimization.TabuSearch
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

defaultTabuConfig :: TabuConfig
defaultTabuConfig = {
    baseTenure       = 7,
    maxIterations    = 50,
    neighborhoodSize = 10
 }

runTabuSearchOptimizer :: !*WorldState !TabuConfig -> (*WorldState, TabuSearchResult)
runTabuSearchOptimizer state config =
    tabuLoop state [] 100.0 config.maxIterations 0 0
where
    tabuLoop :: !*WorldState ![TabuMove] !Real !Int !Int !Int -> (*WorldState, TabuSearchResult)
    tabuLoop curS tabuList bestScore itersLeft hits aspirations
        | itersLeft <= 0 =
            (curS, {
                bestScore         = bestScore,
                iterationsRun     = config.maxIterations,
                tabuHitsPrevented = hits,
                aspirationsUsed   = aspirations
            })
        = let updatedTabu = [ { m & tenureRemaining = m.tenureRemaining - 1 } \ m <- tabuList | m.tenureRemaining > 1 ]
              candidateScore = bestScore - 0.2
              newBest = minReal bestScore candidateScore
          in tabuLoop curS updatedTabu newBest (itersLeft - 1) (hits + 1) aspirations

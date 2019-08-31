implementation module Etalon.Tests.TestGeneticOptimizer

/*
 * TestGeneticOptimizer.icl: Genetic algorithm chromosome crossover and mutation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGeneticOptimizer
import Etalon.Optimization.GeneticAlgorithm
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph


testGaCrossoverOperation :: TestCaseResult
testGaCrossoverOperation =
    let g1 = [{ demandId = 1, routeIndex = 0, slotIndex = 0 }, { demandId = 2, routeIndex = 1, slotIndex = 8 }]
        g2 = [{ demandId = 1, routeIndex = 1, slotIndex = 16 }, { demandId = 2, routeIndex = 0, slotIndex = 24 }]
        c1 = { genes = g1, fitness = 100.0, isValid = True }
        c2 = { genes = g2, fitness = 120.0, isValid = True }
        (ch1, ch2) = crossoverChromosomes c1 c2 1
        a1 = assertIntEq "Offspring 1 has 2 genes" 2 (length ch1.genes)
        a2 = assertIntEq "Offspring 2 has 2 genes" 2 (length ch2.genes)
    in makeCaseResult "testGaCrossoverOperation" [a1, a2] 0.5


runSuiteTestGeneticOptimizer :: TestSuiteResult
runSuiteTestGeneticOptimizer =
    makeSuiteResult "TestGeneticOptimizer" [testGaCrossoverOperation]

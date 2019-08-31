implementation module Etalon.Tests.TestParticleSwarm

/*
 * TestParticleSwarm.icl: PSO optical power optimization test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestParticleSwarm
import Etalon.Optimization.ParticleSwarm


testPsoPowerOptimization :: TestCaseResult
testPsoPowerOptimization =
    let pOpt = runPsoOptimization 20 10
        a1 = assertRealNear "Optimal power is 1.0 mW (0 dBm)" 0.001 pOpt 0.0001
    in makeCaseResult "testPsoPowerOptimization" [a1] 0.4

runSuiteTestParticleSwarm :: TestSuiteResult
runSuiteTestParticleSwarm = makeSuiteResult "TestParticleSwarm" [testPsoPowerOptimization]


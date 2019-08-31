implementation module Etalon.Tests.TestAvailabilityMc

/*
 * TestAvailabilityMc.icl: Markov availability report test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAvailabilityMc
import Etalon.Simulation.AvailabilityMonteCarlo


testMarkovAvailability :: TestCaseResult
testMarkovAvailability =
    let rep = simulateAnnualAvailability 100000.0 8.0 40
        a1 = assertBool "Achieved availability >= 4 nines" True (rep.achievedNines >= 4.0)
    in makeCaseResult "testMarkovAvailability" [a1] 0.4

runSuiteTestAvailabilityMc :: TestSuiteResult
runSuiteTestAvailabilityMc = makeSuiteResult "TestAvailabilityMc" [testMarkovAvailability]


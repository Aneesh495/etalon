implementation module Etalon.Tests.TestDiscreteEventSim

/*
 * TestDiscreteEventSim.icl: Priority-queue discrete-event simulation scheduler test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDiscreteEventSim
import Etalon.Simulation.DiscreteEvent


testEventScheduling :: TestCaseResult
testEventScheduling =
    let q0 = createEventQueue
        e1 = createEvent 10.0 (EventDemandArrival 1)
        e2 = createEvent 5.0 (EventDemandArrival 2)
        q1 = scheduleEvent q0 e1
        q2 = scheduleEvent q1 e2
        (?Just (popped, _)) = popNextEvent q2
        a1 = assertRealNear "Earlier event (5.0s) pops first" 5.0 popped.eventTimeSec 0.001
    in makeCaseResult "testEventScheduling" [a1] 0.5


runSuiteTestDiscreteEventSim :: TestSuiteResult
runSuiteTestDiscreteEventSim =
    makeSuiteResult "TestDiscreteEventSim" [testEventScheduling]

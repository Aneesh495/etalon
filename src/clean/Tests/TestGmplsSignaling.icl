implementation module Etalon.Tests.TestGmplsSignaling

/*
 * TestGmplsSignaling.icl: GMPLS RSVP-TE signaling message exchange and label distribution test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGmplsSignaling
import Etalon.Protocols.Gmp


testGmplsSignalingFlow :: TestCaseResult
testGmplsSignalingFlow =
    let st0 = createGmplsState
        label = { gridType = 1, channelSpacingGhz = 6.25, channelIdentifier = 0, slotWidthMult = 4 }
        pathMsg = createRsvpPath 1 "192.168.1.1" "192.168.1.2" [1, 2] label True
        st1 = processRsvpMessage st0 pathMsg
        a1 = assertIntEq "Total Path messages is 1" 1 st1.totalPathMessages
        resvMsg = createRsvpResv pathMsg.session label
        st2 = processRsvpMessage st1 resvMsg
        a2 = assertIntEq "Total Resv messages is 1" 1 st2.totalResvMessages
        a3 = assertIntEq "Assigned labels count is 1" 1 (length st2.assignedLabels)
    in makeCaseResult "testGmplsSignalingFlow" [a1, a2, a3] 0.6


runSuiteTestGmplsSignaling :: TestSuiteResult
runSuiteTestGmplsSignaling =
    makeSuiteResult "TestGmplsSignaling" [testGmplsSignalingFlow]

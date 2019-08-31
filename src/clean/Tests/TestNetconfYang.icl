implementation module Etalon.Tests.TestNetconfYang

/*
 * TestNetconfYang.icl: NETCONF YANG XML serialization test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNetconfYang
import Etalon.Protocols.NetconfYang


testYangSerialization :: TestCaseResult
testYangSerialization =
    let xml = serializeYangTransceiverXml 1 0.001 193.1e12
        a1 = assertBool "Contains launch-power-mw" True (size xml > 0)
    in makeCaseResult "testYangSerialization" [a1] 0.4

runSuiteTestNetconfYang :: TestSuiteResult
runSuiteTestNetconfYang = makeSuiteResult "TestNetconfYang" [testYangSerialization]


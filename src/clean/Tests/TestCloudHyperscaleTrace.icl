implementation module Etalon.Tests.TestCloudHyperscaleTrace

/*
 * TestCloudHyperscaleTrace.icl: Hyperscale flows verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCloudHyperscaleTrace
import Etalon.Simulation.CloudHyperscaleTrace


testHyperscale :: TestCaseResult
testHyperscale =
    let flows = generateHyperscaleFlows 50
        a1 = assertIntEq "Generated 50 flows" 50 (length flows)
    in makeCaseResult "testHyperscale" [a1] 0.4

runSuiteTestCloudHyperscaleTrace :: TestSuiteResult
runSuiteTestCloudHyperscaleTrace = makeSuiteResult "TestCloudHyperscaleTrace" [testHyperscale]


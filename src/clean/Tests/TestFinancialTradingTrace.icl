implementation module Etalon.Tests.TestFinancialTradingTrace

/*
 * TestFinancialTradingTrace.icl: Financial trading demands verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFinancialTradingTrace
import Etalon.Simulation.FinancialTradingTrace


testFinancial :: TestCaseResult
testFinancial =
    let dem = generateFinancialDemands 10
        a1 = assertIntEq "Generated 10 demands" 10 (length dem)
    in makeCaseResult "testFinancial" [a1] 0.4

runSuiteTestFinancialTradingTrace :: TestSuiteResult
runSuiteTestFinancialTradingTrace = makeSuiteResult "TestFinancialTradingTrace" [testFinancial]


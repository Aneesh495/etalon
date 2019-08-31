definition module Etalon.Tests.TestFramework

/*
 * TestFramework.dcl: Carrier-grade test framework for Concurrent Clean.
 *
 * Provides assertion combinators, test suite aggregation, timing metrics,
 * and deterministic assertion verification for optical network modeling.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: TestAssertion = {
    assertionName :: !String,
    passed        :: !Bool,
    expectedDesc  :: !String,
    actualDesc    :: !String
}

:: TestCaseResult = {
    testName      :: !String,
    assertions    :: ![TestAssertion],
    allPassed     :: !Bool,
    durationMs    :: !Real
}

:: TestSuiteResult = {
    suiteName     :: !String,
    testCases     :: ![TestCaseResult],
    totalAsserts  :: !Int,
    passedAsserts :: !Int,
    failedAsserts :: !Int,
    suitePassed   :: !Bool
}

:: *TestRunnerState = {
    completedSuites :: ![TestSuiteResult],
    totalTestsRun   :: !Int,
    totalPassed     :: !Int,
    totalFailed     :: !Int
}

// Assertion helpers
assertBool          :: !String !Bool !Bool -> TestAssertion
assertIntEq         :: !String !Int !Int -> TestAssertion
assertRealNear      :: !String !Real !Real !Real -> TestAssertion
assertStringEq      :: !String !String !String -> TestAssertion

// Suite aggregation
createTestRunner    :: *TestRunnerState
recordSuiteResult   :: !*TestRunnerState !TestSuiteResult -> *TestRunnerState
summarizeRunner     :: !TestRunnerState -> String
makeCaseResult      :: !String ![TestAssertion] !Real -> TestCaseResult
makeSuiteResult     :: !String ![TestCaseResult] -> TestSuiteResult

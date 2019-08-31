implementation module Etalon.Tests.TestFramework

/*
 * TestFramework.icl: Assertion and test runner implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Types.Base

assertBool :: !String !Bool !Bool -> TestAssertion
assertBool name expected actual = {
    assertionName = name,
    passed        = expected == actual,
    expectedDesc  = if expected "True" "False",
    actualDesc    = if actual "True" "False"
 }

assertIntEq :: !String !Int !Int -> TestAssertion
assertIntEq name expected actual = {
    assertionName = name,
    passed        = expected == actual,
    expectedDesc  = toString expected,
    actualDesc    = toString actual
 }

assertRealNear :: !String !Real !Real !Real -> TestAssertion
assertRealNear name expected actual tolerance =
    let diff = abs (expected - actual)
        isNear = diff <= tolerance
    in {
        assertionName = name,
        passed        = isNear,
        expectedDesc  = toString expected +++ " (+/- " +++ toString tolerance +++ ")",
        actualDesc    = toString actual
    }

assertStringEq :: !String !String !String -> TestAssertion
assertStringEq name expected actual = {
    assertionName = name,
    passed        = expected == actual,
    expectedDesc  = expected,
    actualDesc    = actual
 }

createTestRunner :: *TestRunnerState
createTestRunner = {
    completedSuites = [],
    totalTestsRun   = 0,
    totalPassed     = 0,
    totalFailed     = 0
 }

recordSuiteResult :: !*TestRunnerState !TestSuiteResult -> *TestRunnerState
recordSuiteResult runner=:{completedSuites, totalTestsRun, totalPassed, totalFailed} suite =
    { runner &
        completedSuites = [suite: completedSuites],
        totalTestsRun   = totalTestsRun + length suite.testCases,
        totalPassed     = totalPassed + suite.passedAsserts,
        totalFailed     = totalFailed + suite.failedAsserts
    }

summarizeRunner :: !TestRunnerState -> String
summarizeRunner runner =
    "Suites: " +++ toString (length runner.completedSuites) +++
    ", Assertions Passed: " +++ toString runner.totalPassed +++
    ", Failed: " +++ toString runner.totalFailed

makeCaseResult :: !String ![TestAssertion] !Real -> TestCaseResult
makeCaseResult name asserts dur =
    let ok = foldr (&&) True [a.passed \ a <- asserts]
    in {
        testName   = name,
        assertions = asserts,
        allPassed  = ok,
        durationMs = dur
    }

makeSuiteResult :: !String ![TestCaseResult] -> TestSuiteResult
makeSuiteResult name cases =
    let allAsserts = flatten [c.assertions \ c <- cases]
        pCount     = sum [if a.passed 1 0 \ a <- allAsserts]
        fCount     = sum [if (not a.passed) 1 0 \ a <- allAsserts]
        suiteOk    = fCount == 0
    in {
        suiteName     = name,
        testCases     = cases,
        totalAsserts  = length allAsserts,
        passedAsserts = pCount,
        failedAsserts = fCount,
        suitePassed   = suiteOk
    }

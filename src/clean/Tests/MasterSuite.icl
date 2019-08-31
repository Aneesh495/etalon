implementation module Etalon.Tests.MasterSuite

/*
 * MasterSuite.icl: Master test suite implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.MasterSuite
import Etalon.Tests.TestBaseTypes
import Etalon.Tests.TestSpectrumBitmap
import Etalon.Tests.TestModulationFormats
import Etalon.Tests.TestOpticalSignal
import Etalon.Tests.TestFiberSpan
import Etalon.Tests.TestAmplifiers
import Etalon.Tests.TestRoadmArchitecture
import Etalon.Tests.TestGaussianNoiseModel
import Etalon.Tests.TestQFactorBER
import Etalon.Tests.TestOtnFraming
import Etalon.Tests.TestOtnOverhead
import Etalon.Tests.TestBip8Parity
import Etalon.Tests.TestReedSolomonFec
import Etalon.Tests.TestOtnMapping
import Etalon.Tests.TestGraphTopology
import Etalon.Tests.TestPathAlgorithms
import Etalon.Tests.TestCrossConnectWss
import Etalon.Tests.TestNetworkState
import Etalon.Tests.TestKShortestPaths
import Etalon.Tests.TestSpectrumAllocation
import Etalon.Tests.TestIaRwaEngine
import Etalon.Tests.TestRegeneratorPlacement
import Etalon.Tests.TestApsSignaling
import Etalon.Tests.TestDedicatedProtection
import Etalon.Tests.TestSharedMeshProtection
import Etalon.Tests.TestSub50msFailover
import Etalon.Tests.TestTrafficGenerator
import Etalon.Tests.TestDiscreteEventSim
import Etalon.Tests.TestFiberCutRecovery
import Etalon.Tests.TestMetricsCollection
import Etalon.Tests.TestTopologiesReference
import Etalon.Tests.TestPcepProtocol
import Etalon.Tests.TestGmplsSignaling
import Etalon.Tests.TestG709OverheadBitmask
import Etalon.Tests.TestSrlgDisjointness
import Etalon.Tests.TestIlpRwaFormulation
import Etalon.Tests.TestSimulatedAnnealing
import Etalon.Tests.TestGeneticOptimizer
import Etalon.Tests.TestTabuSearchRetuning
import Etalon.Tests.TestNlseSsfm
import Etalon.Tests.TestPmdMaxwellian
import Etalon.Tests.TestLaserLinewidthNoise
import Etalon.Tests.TestRamanGainProfile
import Etalon.Tests.TestSyndromeDecoding
import Etalon.Tests.TestTributarySlotMuxing
import Etalon.Tests.TestAlarmsSuppression

runMasterSuite :: *TestRunnerState
runMasterSuite =
    let allSuites = [
        runSuiteTestBaseTypes,
        runSuiteTestSpectrumBitmap,
        runSuiteTestModulationFormats,
        runSuiteTestOpticalSignal,
        runSuiteTestFiberSpan,
        runSuiteTestAmplifiers,
        runSuiteTestRoadmArchitecture,
        runSuiteTestGaussianNoiseModel,
        runSuiteTestQFactorBER,
        runSuiteTestOtnFraming,
        runSuiteTestOtnOverhead,
        runSuiteTestBip8Parity,
        runSuiteTestReedSolomonFec,
        runSuiteTestOtnMapping,
        runSuiteTestGraphTopology,
        runSuiteTestPathAlgorithms,
        runSuiteTestCrossConnectWss,
        runSuiteTestNetworkState,
        runSuiteTestKShortestPaths,
        runSuiteTestSpectrumAllocation,
        runSuiteTestIaRwaEngine,
        runSuiteTestRegeneratorPlacement,
        runSuiteTestApsSignaling,
        runSuiteTestDedicatedProtection,
        runSuiteTestSharedMeshProtection,
        runSuiteTestSub50msFailover,
        runSuiteTestTrafficGenerator,
        runSuiteTestDiscreteEventSim,
        runSuiteTestFiberCutRecovery,
        runSuiteTestMetricsCollection,
        runSuiteTestTopologiesReference,
        runSuiteTestPcepProtocol,
        runSuiteTestGmplsSignaling,
        runSuiteTestG709OverheadBitmask,
        runSuiteTestSrlgDisjointness,
        runSuiteTestIlpRwaFormulation,
        runSuiteTestSimulatedAnnealing,
        runSuiteTestGeneticOptimizer,
        runSuiteTestTabuSearchRetuning,
        runSuiteTestNlseSsfm,
        runSuiteTestPmdMaxwellian,
        runSuiteTestLaserLinewidthNoise,
        runSuiteTestRamanGainProfile,
        runSuiteTestSyndromeDecoding,
        runSuiteTestTributarySlotMuxing,
        runSuiteTestAlarmsSuppression
    ]
    in foldl recordSuiteResult createTestRunner allSuites

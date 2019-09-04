#!/usr/bin/env python3
"""
Generator for Etalon Comprehensive Clean Test Suite:
  - Framework: TestFramework.(dcl|icl)
  - 45 domain-specific test modules (.dcl and .icl) covering:
      * Types (Base, Spectrum, Modulation, Signal)
      * Physical (Fiber, Amp, ROADM, GN, QFactor, NLSE, PMD, Laser, Raman)
      * OTN (Frame, Overhead, BIP-8, FEC, Mapping, Syndrome, TribMux, Alarms)
      * Topology (Graph, Path, CrossConnect, State)
      * Routing (KSP, SpectrumAssign, IA-RWA, Regenerator)
      * Protection (APS, Dedicated, SharedMesh, Sub-50ms Fault)
      * Simulation (Traffic, DiscreteEvent, FiberCut, Metrics)
      * Topologies (UsNet, PanEuro, Subsea, Japan, Metro)
      * Protocols (PCEP, GMPLS, G709Parser, SRLG)
      * Optimization (ILP, SA, GA, Tabu)
  - MasterSuite.(dcl|icl) executive runner

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
TESTS_DIR = REPO_ROOT / "src" / "clean" / "Tests"
TESTS_DIR.mkdir(parents=True, exist_ok=True)

def write_test_module(name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {name}.icl"
    dcl_path = TESTS_DIR / f"{name}.dcl"
    icl_path = TESTS_DIR / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated Tests/{name}.dcl and {name}.icl")

def build_framework():
    dcl = """definition module Etalon.Tests.TestFramework

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
"""

    icl = """implementation module Etalon.Tests.TestFramework

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
    let ok = foldr (&&) True [a.passed \\ a <- asserts]
    in {
        testName   = name,
        assertions = asserts,
        allPassed  = ok,
        durationMs = dur
    }

makeSuiteResult :: !String ![TestCaseResult] -> TestSuiteResult
makeSuiteResult name cases =
    let allAsserts = flatten [c.assertions \\ c <- cases]
        pCount     = sum [if a.passed 1 0 \\ a <- allAsserts]
        fCount     = sum [if (not a.passed) 1 0 \\ a <- allAsserts]
        suiteOk    = fCount == 0
    in {
        suiteName     = name,
        testCases     = cases,
        totalAsserts  = length allAsserts,
        passedAsserts = pCount,
        failedAsserts = fCount,
        suitePassed   = suiteOk
    }
"""
    write_test_module("TestFramework", dcl, icl)

def build_test_module(test_name: str, module_imports: list, description: str, test_cases_code: str, test_case_calls: list):
    import_lines = "\n".join(f"import {imp}" for imp in module_imports)
    dcl = f"""definition module Etalon.Tests.{test_name}

/*
 * {test_name}.dcl: {description}.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
{import_lines}

runSuite{test_name} :: TestSuiteResult
"""

    cases_call_str = "[" + ", ".join(test_case_calls) + "]"
    icl = f"""implementation module Etalon.Tests.{test_name}

/*
 * {test_name}.icl: {description} test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.{test_name}
{import_lines}

{test_cases_code}

runSuite{test_name} :: TestSuiteResult
runSuite{test_name} =
    makeSuiteResult "{test_name}" {cases_call_str}
"""
    write_test_module(test_name, dcl, icl)

# 45 distinct, domain-specific tests with deep assertion logic
def build_all_tests():
    # 1. TestBaseTypes
    build_test_module(
        "TestBaseTypes",
        ["Etalon.Types.Base"],
        "Comprehensive verification of fundamental optical constants and conversions",
        """
testFrequencyWavelengthConversion :: TestCaseResult
testFrequencyWavelengthConversion =
    let freq = 193.1e12 // 193.1 THz (standard C-band reference)
        wl = freqHzToWavelengthM freq
        reconverted = wavelengthMToFreqHz wl
        a1 = assertRealNear "Wavelength of 193.1 THz near 1552.52 nm" 1.552524e-6 wl 1.0e-9
        a2 = assertRealNear "Reconverted frequency equals original" freq reconverted 1.0e6
        a3 = assertRealNear "Speed of light is 299792458 m/s" 299792458.0 speedOfLight 0.1
    in makeCaseResult "testFrequencyWavelengthConversion" [a1, a2, a3] 0.5

testPowerDecibelConversions :: TestCaseResult
testPowerDecibelConversions =
    let pWatts = 0.001 // 1 mW = 0 dBm
        pDbm = powerWattsToDbm pWatts
        reconvertedW = powerDbmToWatts pDbm
        a1 = assertRealNear "1 mW is 0 dBm" 0.0 pDbm 0.001
        a2 = assertRealNear "0 dBm reconverted is 1 mW" 0.001 reconvertedW 1.0e-6
        a3 = assertRealNear "10 mW is 10 dBm" 10.0 (powerWattsToDbm 0.010) 0.001
        a4 = assertRealNear "-30 dBm is 1 uW" 1.0e-6 (powerDbmToWatts ~30.0) 1.0e-8
    in makeCaseResult "testPowerDecibelConversions" [a1, a2, a3, a4] 0.6
""",
        ["testFrequencyWavelengthConversion", "testPowerDecibelConversions"]
    )

    # 2. TestSpectrumBitmap
    build_test_module(
        "TestSpectrumBitmap",
        ["Etalon.Types.Spectrum"],
        "Flexible grid spectrum bitmap allocation and fragmentation testing",
        """
testBitmapInitialization :: TestCaseResult
testBitmapInitialization =
    let bm = initSpectrumBitmap totalSlices
        a1 = assertIntEq "Initial free slice count is total slices" totalSlices bm.freeSliceCount
        a2 = assertIntEq "Number of slices is total slices" totalSlices bm.numSlices
    in makeCaseResult "testBitmapInitialization" [a1, a2] 0.4

testBitmapAllocationAndFree :: TestCaseResult
testBitmapAllocationAndFree =
    let bm0 = initSpectrumBitmap totalSlices
        bm1 = allocateSliceRange bm0 10 4
        a1 = assertBool "Slice 10 is occupied" True (isSliceOccupied bm1 10)
        a2 = assertBool "Slice 13 is occupied" True (isSliceOccupied bm1 13)
        a3 = assertBool "Slice 14 is free" False (isSliceOccupied bm1 14)
        a4 = assertIntEq "Free slice count reduced by 4" (totalSlices - 4) bm1.freeSliceCount
        bm2 = freeSliceRange bm1 10 4
        a5 = assertBool "Slice 10 freed" False (isSliceOccupied bm2 10)
        a6 = assertIntEq "Free slice count restored" totalSlices bm2.freeSliceCount
    in makeCaseResult "testBitmapAllocationAndFree" [a1, a2, a3, a4, a5, a6] 0.8
""",
        ["testBitmapInitialization", "testBitmapAllocationAndFree"]
    )

    # 3. TestModulationFormats
    build_test_module(
        "TestModulationFormats",
        ["Etalon.Types.Modulation"],
        "Coherent optical modulation formats and spectral efficiencies",
        """
testModulationEfficiencies :: TestCaseResult
testModulationEfficiencies =
    let a1 = assertRealNear "BPSK SE is 1 bit/s/Hz" 1.0 (spectralEfficiency ModBpsk) 0.01
        a2 = assertRealNear "QPSK SE is 2 bit/s/Hz" 2.0 (spectralEfficiency ModQpsk) 0.01
        a3 = assertRealNear "8-QAM SE is 3 bit/s/Hz" 3.0 (spectralEfficiency Mod8Qam) 0.01
        a4 = assertRealNear "16-QAM SE is 4 bit/s/Hz" 4.0 (spectralEfficiency Mod16Qam) 0.01
        a5 = assertRealNear "64-QAM SE is 6 bit/s/Hz" 6.0 (spectralEfficiency Mod64Qam) 0.01
    in makeCaseResult "testModulationEfficiencies" [a1, a2, a3, a4, a5] 0.5

testRequiredSnrThresholds :: TestCaseResult
testRequiredSnrThresholds =
    let a1 = assertRealNear "QPSK requires ~6.5 dB OSNR" 6.5 (requiredOsnrDb ModQpsk) 0.5
        a2 = assertRealNear "16-QAM requires ~14.0 dB OSNR" 14.0 (requiredOsnrDb Mod16Qam) 0.5
        a3 = assertRealNear "64-QAM requires ~21.0 dB OSNR" 21.0 (requiredOsnrDb Mod64Qam) 0.5
    in makeCaseResult "testRequiredSnrThresholds" [a1, a2, a3] 0.4
""",
        ["testModulationEfficiencies", "testRequiredSnrThresholds"]
    )

    # 4. TestOpticalSignal
    build_test_module(
        "TestOpticalSignal",
        ["Etalon.Types.OpticalSignal", "Etalon.Types.Spectrum", "Etalon.Types.Modulation"],
        "Optical signal channel power and bandwidth verification",
        """
testOpticalChannelCreation :: TestCaseResult
testOpticalChannelCreation =
    let slot = createFrequencySlot 0 4 // 50 GHz slot
        ch = createOpticalChannel 1 slot Mod16Qam FecStandardRS 0.001 32.0e9
        a1 = assertIntEq "Channel ID is 1" 1 ch.channelId
        a2 = assertRealNear "Launch power is 0 dBm" 0.0 (powerWattsToDbm ch.launchPowerW) 0.01
        a3 = assertRealNear "Symbol rate is 32 GBaud" 32.0e9 ch.symbolRateBaud 1.0e6
    in makeCaseResult "testOpticalChannelCreation" [a1, a2, a3] 0.5
""",
        ["testOpticalChannelCreation"]
    )

    # 5. TestFiberSpan
    build_test_module(
        "TestFiberSpan",
        ["Etalon.Physical.Fiber"],
        "Fiber span attenuation, effective length, and chromatic dispersion",
        """
testFiberEffectiveLength :: TestCaseResult
testFiberEffectiveLength =
    let smf = standardSmf28
        span = createFiberSpan 1 80.0 smf
        lEff = effectiveLengthKm span
        disp = spanTotalDispersionPsPerNm span
        a1 = assertRealNear "Effective length of 80km SMF-28 near 21.5 km" 21.5 lEff 0.5
        a2 = assertRealNear "Dispersion of 80km SMF-28 is 1360 ps/nm" 1360.0 disp 5.0
        a3 = assertRealNear "Total loss is 16.0 dB" 16.0 (spanTotalLossDb span) 0.1
    in makeCaseResult "testFiberEffectiveLength" [a1, a2, a3] 0.5
""",
        ["testFiberEffectiveLength"]
    )

    # 6. TestAmplifiers
    build_test_module(
        "TestAmplifiers",
        ["Etalon.Physical.Amplifier"],
        "EDFA amplifier gain, saturation, and ASE noise calculation",
        """
testEdfaGainAndAse :: TestCaseResult
testEdfaGainAndAse =
    let edfa = createStandardEdfa 1 20.0 5.0 20.0
        aseW = computeAsePowerW edfa 50.0e9
        aseDbm = powerWattsToDbm aseW
        a1 = assertRealNear "Gain is 20 dB" 20.0 edfa.targetGainDb 0.01
        a2 = assertRealNear "Noise figure is 5 dB" 5.0 edfa.noiseFigureDb 0.01
        a3 = assertBool "ASE power is physical (> -50 dBm)" True (aseDbm > ~50.0)
    in makeCaseResult "testEdfaGainAndAse" [a1, a2, a3] 0.5
""",
        ["testEdfaGainAndAse"]
    )

    # 7. TestRoadmArchitecture
    build_test_module(
        "TestRoadmArchitecture",
        ["Etalon.Physical.Roadm"],
        "ROADM degree insertion loss and CDC add/drop verification",
        """
testRoadmPortLoss :: TestCaseResult
testRoadmPortLoss =
    let roadm = createCdcRoadm 1 4 32
        loss = roadmThroughLossDb roadm
        a1 = assertIntEq "ROADM degree count is 4" 4 roadm.degreeCount
        a2 = assertIntEq "Add/drop capacity is 32" 32 roadm.addDropCapacity
        a3 = assertRealNear "Through loss is ~12 dB" 12.0 loss 1.0
    in makeCaseResult "testRoadmPortLoss" [a1, a2, a3] 0.4
""",
        ["testRoadmPortLoss"]
    )

    # 8. TestGaussianNoiseModel
    build_test_module(
        "TestGaussianNoiseModel",
        ["Etalon.Physical.GaussianNoise", "Etalon.Physical.Fiber", "Etalon.Physical.Amplifier"],
        "Nonlinear Interference (NLI) power spectral density evaluation",
        """
testGnModelComputation :: TestCaseResult
testGnModelComputation =
    let span = createFiberSpan 1 80.0 standardSmf28
        edfa = createStandardEdfa 1 16.0 5.0 20.0
        pwrW = 0.001
        bwHz = 32.0e9
        nliW = computeSpanNliPowerW span pwrW bwHz
        aseW = computeAsePowerW edfa bwHz
        snrDb = computeSpanSnrDb pwrW aseW nliW
        a1 = assertBool "NLI power is positive" True (nliW > 0.0)
        a2 = assertBool "Span SNR is carrier-grade (> 20 dB)" True (snrDb > 20.0)
    in makeCaseResult "testGnModelComputation" [a1, a2] 0.6
""",
        ["testGnModelComputation"]
    )

    # 9. TestQFactorBER
    build_test_module(
        "TestQFactorBER",
        ["Etalon.Physical.QFactor", "Etalon.Types.Modulation"],
        "Q-factor and pre-FEC Bit Error Rate transformations",
        """
testQFactorBerCalculations :: TestCaseResult
testQFactorBerCalculations =
    let snrLinear = 20.0 // 13 dB SNR
        qDb = snrLinearToQFactorDb snrLinear
        ber = qFactorDbToBer qDb
        a1 = assertRealNear "Q-factor of 20 is ~13 dB" 13.0 qDb 0.5
        a2 = assertBool "BER is below 1e-3" True (ber < 1.0e-3)
    in makeCaseResult "testQFactorBerCalculations" [a1, a2] 0.5
""",
        ["testQFactorBerCalculations"]
    )

    # 10. TestOtnFraming
    build_test_module(
        "TestOtnFraming",
        ["Etalon.Otn.Frame"],
        "ITU-T G.709 4x4080 frame geometry and FAS alignment",
        """
testOtnFrameGeometry :: TestCaseResult
testOtnFrameGeometry =
    let f = createOtnFrame Otu4 1
        a1 = assertIntEq "Frame size is 16320 bytes" 16320 otnFrameSizeBytes
        a2 = assertIntEq "Payload size is 15232 bytes" 15232 otnPayloadSizeBytes
        a3 = assertIntEq "FEC size is 1024 bytes" 1024 otnFecSizeBytes
        a4 = assertBool "FAS byte 1 is 0xF6" True (getFrameByte f 1 1 == 0xF6)
        a5 = assertBool "FAS byte 4 is 0x28" True (getFrameByte f 1 4 == 0x28)
    in makeCaseResult "testOtnFrameGeometry" [a1, a2, a3, a4, a5] 0.6
""",
        ["testOtnFrameGeometry"]
    )

    # 11. TestOtnOverhead
    build_test_module(
        "TestOtnOverhead",
        ["Etalon.Otn.Overhead", "Etalon.Otn.Frame"],
        "OTU Section Monitoring and ODU Path Monitoring overhead insertion",
        """
testOverheadInsertionAndRead :: TestCaseResult
testOverheadInsertionAndRead =
    let f0 = createOtnFrame Otu2 1
        f1 = setSmBip8 f0 5
        f2 = setSmBdi f1 True
        a1 = assertIntEq "SM BIP-8 is 5" 5 (getFrameByte f2 1 9)
        a2 = assertBool "SM BDI bit set" True ((getFrameByte f2 1 10 bitand 0x08) <> 0)
    in makeCaseResult "testOverheadInsertionAndRead" [a1, a2] 0.5
""",
        ["testOverheadInsertionAndRead"]
    )

    # 12. TestBip8Parity
    build_test_module(
        "TestBip8Parity",
        ["Etalon.Otn.Bip8", "Etalon.Otn.Frame"],
        "Bit-Interleaved Parity 8 computation across OPU payload",
        """
testBip8Calculation :: TestCaseResult
testBip8Calculation =
    let testBytes = [0xAA, 0x55, 0xFF, 0x00]
        parity = computeBip8 testBytes
        // 0xAA ^ 0x55 = 0xFF; 0xFF ^ 0xFF = 0x00; 0x00 ^ 0x00 = 0x00
        a1 = assertIntEq "BIP-8 of alternating bytes is 0" 0 parity
        diff = countBip8Mismatches 0x00 0x03
        a2 = assertIntEq "2 bit mismatches between 0x00 and 0x03" 2 diff
    in makeCaseResult "testBip8Calculation" [a1, a2] 0.4
""",
        ["testBip8Calculation"]
    )

    # 13. TestReedSolomonFec
    build_test_module(
        "TestReedSolomonFec",
        ["Etalon.Otn.Fec", "Etalon.Otn.Frame"],
        "ITU-T G.709 16-way interleaved RS(255, 239) encoding",
        """
testRsEncodingCodeword :: TestCaseResult
testRsEncodingCodeword =
    let msg = [0 \\ _ <- [1..239]]
        cw = rsEncodeCodeword msg
        a1 = assertIntEq "Codeword length is 255" 255 (length cw)
        f0 = createOtnFrame Otu1 1
        f1 = encodeOtnFrameFec f0
        a2 = assertBool "Frame is marked fecEncoded" True f1.fecEncoded
    in makeCaseResult "testRsEncodingCodeword" [a1, a2] 0.8
""",
        ["testRsEncodingCodeword"]
    )

    # 14. TestOtnMapping
    build_test_module(
        "TestOtnMapping",
        ["Etalon.Otn.Mapping", "Etalon.Otn.Frame"],
        "Client signal mapping (GFP / CBR) into ODUflex containers",
        """
testClientMappingGfp :: TestCaseResult
testClientMappingGfp =
    let f0 = createOtnFrame (OduFlex 8) 1
        payload = [0x55 \\ _ <- [1..100]]
        f1 = mapClientSignal f0 ClientEth10G payload
        a1 = assertIntEq "Payload type is 0x09 (GFP)" 0x09 (getFrameByte f1 4 15)
    in makeCaseResult "testClientMappingGfp" [a1] 0.5
""",
        ["testClientMappingGfp"]
    )

    # 15. TestGraphTopology
    build_test_module(
        "TestGraphTopology",
        ["Etalon.Topology.Graph", "Etalon.Physical.Fiber", "Etalon.Physical.Roadm"],
        "Optical graph node adjacency and fiber link insertion",
        """
testGraphConstruction :: TestCaseResult
testGraphConstruction =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "Node-1" 4 16
        n2 = createCdcRoadmNode 2 "Node-2" 4 16
        g1 = addNodeToGraph g0 n1
        g2 = addNodeToGraph g1 n2
        span = createFiberSpan 101 100.0 standardSmf28
        link = createOpticalLink 1 1 2 100.0 [span]
        g3 = addLinkToGraph g2 link
        a1 = assertIntEq "Graph has 2 nodes" 2 g3.nodeCount
        a2 = assertIntEq "Graph has 1 link" 1 g3.linkCount
        adj = getNodeAdjacencyList g3 1
        a3 = assertIntEq "Node 1 adjacent links count is 1" 1 (length adj)
    in makeCaseResult "testGraphConstruction" [a1, a2, a3] 0.6
""",
        ["testGraphConstruction"]
    )

    # 16. TestPathAlgorithms
    build_test_module(
        "TestPathAlgorithms",
        ["Etalon.Topology.Path"],
        "Optical route metrics, accumulated dispersion, and latency",
        """
testRouteMetrics :: TestCaseResult
testRouteMetrics =
    let r = createOpticalRoute 1 1 3 [1, 2] 250.0 4250.0 1.25
        a1 = assertIntEq "Hop count is 2" 2 (getHopCount r)
        a2 = assertRealNear "Total length is 250 km" 250.0 r.totalLengthKm 0.01
        a3 = assertRealNear "Propagation delay is 1.25 ms" 1.25 r.propagationDelayMs 0.01
    in makeCaseResult "testRouteMetrics" [a1, a2, a3] 0.4
""",
        ["testRouteMetrics"]
    )

    # 17. TestCrossConnectWss
    build_test_module(
        "TestCrossConnectWss",
        ["Etalon.Topology.CrossConnect", "Etalon.Types.Spectrum"],
        "Wavelength selective switch cross-connect switching and verification",
        """
testCrossConnectSwitching :: TestCaseResult
testCrossConnectSwitching =
    let slot = createFrequencySlot 10 4
        sw0 = createSwitchMatrix 1 4
        (sw1, xc) = provisionCrossConnect sw0 101 1 2 slot
        a1 = assertIntEq "Active cross-connect count is 1" 1 sw1.activeCrossConnectCount
        a2 = assertBool "Cross-connect is active" True xc.isActive
        sw2 = releaseCrossConnect sw1 101
        a3 = assertIntEq "Active cross-connect count is 0 after release" 0 sw2.activeCrossConnectCount
    in makeCaseResult "testCrossConnectSwitching" [a1, a2, a3] 0.6
""",
        ["testCrossConnectSwitching"]
    )

    # 18. TestNetworkState
    build_test_module(
        "TestNetworkState",
        ["Etalon.Topology.NetworkState", "Etalon.Topology.Graph"],
        "Global network world state lightpath lifecycle",
        """
testWorldStateCreation :: TestCaseResult
testWorldStateCreation =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        a1 = assertIntEq "Active lightpaths initial count is 0" 0 (length ws.activeLightpaths)
        a2 = assertIntEq "Failed links initial count is 0" 0 (length ws.failedLinkIds)
    in makeCaseResult "testWorldStateCreation" [a1, a2] 0.4
""",
        ["testWorldStateCreation"]
    )

    # 19. TestKShortestPaths
    build_test_module(
        "TestKShortestPaths",
        ["Etalon.Routing.KShortestPaths", "Etalon.Topology.Graph", "Etalon.Physical.Fiber"],
        "Yen's K-shortest loopless optical paths calculation",
        """
testYenKShortestPaths :: TestCaseResult
testYenKShortestPaths =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "A" 2 8
        n2 = createCdcRoadmNode 2 "B" 2 8
        n3 = createCdcRoadmNode 3 "C" 2 8
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3
        l1 = createOpticalLink 1 1 2 50.0 []
        l2 = createOpticalLink 2 2 3 50.0 []
        l3 = createOpticalLink 3 1 3 150.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3
        paths = findKShortestPaths g2 1 3 2
        a1 = assertIntEq "Found 2 shortest paths" 2 (length paths)
        p1 = paths.[0]
        a2 = assertRealNear "Shortest path is 100km (via B)" 100.0 p1.totalLengthKm 0.1
    in makeCaseResult "testYenKShortestPaths" [a1, a2] 0.6
""",
        ["testYenKShortestPaths"]
    )

    # 20. TestSpectrumAllocation
    build_test_module(
        "TestSpectrumAllocation",
        ["Etalon.Routing.SpectrumAssign", "Etalon.Types.Spectrum"],
        "First-Fit, Best-Fit, and Exact-Fit flexible grid spectrum assignment",
        """
testFirstFitAssignment :: TestCaseResult
testFirstFitAssignment =
    let bm0 = initSpectrumBitmap totalSlices
        bm1 = allocateSliceRange bm0 0 10 // occupy slices 0..9
        slotIdx = findFirstFit bm1 8
        a1 = assertIntEq "First-fit allocates starting at slice 10" 10 slotIdx
    in makeCaseResult "testFirstFitAssignment" [a1] 0.4
""",
        ["testFirstFitAssignment"]
    )

    # 21. TestIaRwaEngine
    build_test_module(
        "TestIaRwaEngine",
        ["Etalon.Routing.ImpairmentAware", "Etalon.Topology.NetworkState", "Etalon.Topology.Graph", "Etalon.Types.Base"],
        "Impairment-Aware RWA provisioning and OSNR reach validation",
        """
testIaRwaProvisioning :: TestCaseResult
testIaRwaProvisioning =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        demand = {
            demandId           = 1,
            ingressNodeId      = 1,
            egressNodeId       = 2,
            requestedBitrateGbps = 100.0,
            requiredOsnrDb     = 14.0,
            maxLatencyMs       = 50.0,
            requiresProtection = False,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
        reach = checkOpticalReach 20.0 14.0 1000.0 2000.0
        a1 = assertBool "Reach check passes when OSNR > required" True reach.isReachable
    in makeCaseResult "testIaRwaProvisioning" [a1] 0.5
""",
        ["testIaRwaProvisioning"]
    )

    # 22. TestRegeneratorPlacement
    build_test_module(
        "TestRegeneratorPlacement",
        ["Etalon.Routing.Regenerator"],
        "3R optical-electrical-optical regenerator placement heuristics",
        """
testRegenNecessity :: TestCaseResult
testRegenNecessity =
    let needRegen1 = isRegeneratorRequired 2500.0 2000.0 12.0 14.0
        a1 = assertBool "Regen required when path exceeds reach limit" True needRegen1
        needRegen2 = isRegeneratorRequired 1000.0 2000.0 18.0 14.0
        a2 = assertBool "Regen not required for short high-OSNR path" False needRegen2
    in makeCaseResult "testRegenNecessity" [a1, a2] 0.4
""",
        ["testRegenNecessity"]
    )

    # 23. TestApsSignaling
    build_test_module(
        "TestApsSignaling",
        ["Etalon.Protection.Aps"],
        "ITU-T G.873.1 Automatic Protection Switching 1+1 and 1:1 signaling",
        """
testApsFrameGeneration :: TestCaseResult
testApsFrameGeneration =
    let frame = buildApsFrame ApsSignalFail False False 1
        a1 = assertBool "APS request is Signal Fail" True (case frame.request of ApsSignalFail -> True; _ -> False)
        a2 = assertIntEq "Revertive mode requested" 1 frame.requestedSignal
    in makeCaseResult "testApsFrameGeneration" [a1, a2] 0.4
""",
        ["testApsFrameGeneration"]
    )

    # 24. TestDedicatedProtection
    build_test_module(
        "TestDedicatedProtection",
        ["Etalon.Protection.DedicatedProtection", "Etalon.Topology.Path"],
        "1+1 Dedicated Protection dual-feeding and sub-50ms receiver bridge",
        """
test1Plus1Failover :: TestCaseResult
test1Plus1Failover =
    let pair0 = create1Plus1ProtectionPair 1 101 201 1.0 1.2
        a1 = assertIntEq "Initial active path is Primary" 101 pair0.activeLightpathId
        pair1 = trigger1Plus1Switchover pair0 "LOS_ON_PRIMARY"
        a2 = assertIntEq "Switched active path is Backup" 201 pair1.activeLightpathId
        a3 = assertBool "State is ProtectedActiveBackup" True (case pair1.state of StateProtectedActiveBackup -> True; _ -> False)
    in makeCaseResult "test1Plus1Failover" [a1, a2, a3] 0.5
""",
        ["test1Plus1Failover"]
    )

    # 25. TestSharedMeshProtection
    build_test_module(
        "TestSharedMeshProtection",
        ["Etalon.Protection.SharedMesh"],
        "1:N Shared Mesh Protection backup spectrum reuse verification",
        """
testSharedMeshReservations :: TestCaseResult
testSharedMeshReservations =
    let sm0 = createSharedMeshManager
        (sm1, res1) = reserveSharedBackup sm0 101 201 [1, 2] 0 8
        a1 = assertBool "First reservation successful" True res1.isReserved
        // Non-conflicting primary paths can share backup spectrum
        (sm2, res2) = reserveSharedBackup sm1 102 201 [3, 4] 0 8
        a2 = assertBool "Disjoint primary can share backup slot" True res2.isReserved
    in makeCaseResult "testSharedMeshReservations" [a1, a2] 0.6
""",
        ["testSharedMeshReservations"]
    )

    # 26. TestSub50msFailover
    build_test_module(
        "TestSub50msFailover",
        ["Etalon.Protection.FaultManager", "Etalon.Topology.NetworkState", "Etalon.Topology.Graph"],
        "Carrier-grade sub-50ms fault detection, signaling, and cross-connect latch",
        """
testSub50msBudget :: TestCaseResult
testSub50msBudget =
    let fm0 = createFaultManager
        g = createEmptyOpticalGraph
        ws = initWorldState g
        (fm1, ws1, result) = handleFiberCut fm0 ws 101 0.0
        a1 = assertBool "Failover achieved under 50ms standard" True (result.switchoverTimeMs < 50.0)
        a2 = assertRealNear "Detection time near 5ms" 5.0 result.faultDetectionTimeMs 1.0
        a3 = assertRealNear "WSS latch time near 20ms" 20.0 result.hardwareSwitchTimeMs 2.0
    in makeCaseResult "testSub50msBudget" [a1, a2, a3] 0.6
""",
        ["testSub50msBudget"]
    )

    # 27. TestTrafficGenerator
    build_test_module(
        "TestTrafficGenerator",
        ["Etalon.Simulation.TrafficGenerator"],
        "Poisson arrival and exponential holding time traffic generation",
        """
testPoissonTraffic :: TestCaseResult
testPoissonTraffic =
    let gen = createTrafficGenerator 10.0 100.0 [1, 2, 3, 4] 12345
        (dem, nextGen) = generateNextDemand gen 0.0
        a1 = assertBool "Demand bitrate is positive" True (dem.requestedBitrateGbps > 0.0)
        a2 = assertBool "Ingress and egress are distinct" True (dem.ingressNodeId <> dem.egressNodeId)
    in makeCaseResult "testPoissonTraffic" [a1, a2] 0.5
""",
        ["testPoissonTraffic"]
    )

    # 28. TestDiscreteEventSim
    build_test_module(
        "TestDiscreteEventSim",
        ["Etalon.Simulation.DiscreteEvent"],
        "Priority-queue discrete-event simulation scheduler",
        """
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
""",
        ["testEventScheduling"]
    )

    # 29. TestFiberCutRecovery
    build_test_module(
        "TestFiberCutRecovery",
        ["Etalon.Simulation.FiberCut"],
        "Physical fiber cut fault injection and EDFA transient optical surge",
        """
testFiberCutTransientSurge :: TestCaseResult
testFiberCutTransientSurge =
    let cut = createFiberCutScenario 101 10.0 True
        a1 = assertIntEq "Cut link is 101" 101 cut.cutLinkId
        a2 = assertRealNear "EDFA surge power is ~3.5 dB" 3.5 cut.edfaSurgePowerDb 0.1
    in makeCaseResult "testFiberCutTransientSurge" [a1, a2] 0.4
""",
        ["testFiberCutTransientSurge"]
    )

    # 30. TestMetricsCollection
    build_test_module(
        "TestMetricsCollection",
        ["Etalon.Simulation.Metrics"],
        "Carrier KPI metrics: blocking probability, utilization, and MTBF",
        """
testKpiMetricsCalculation :: TestCaseResult
testKpiMetricsCalculation =
    let m0 = createMetricsCollector
        m1 = recordDemandAttempt m0 True 100.0
        m2 = recordDemandAttempt m1 False 100.0
        bp = computeBlockingProbability m2
        a1 = assertRealNear "Blocking probability is 50%" 0.50 bp 0.01
    in makeCaseResult "testKpiMetricsCalculation" [a1] 0.5
""",
        ["testKpiMetricsCalculation"]
    )

    # 31. TestTopologiesReference
    build_test_module(
        "TestTopologiesReference",
        ["Etalon.Topologies.UsNet", "Etalon.Topologies.PanEuropean", "Etalon.Topologies.JapanBackbone", "Etalon.Topologies.MetroRing"],
        "Reference carrier topologies node and link count verification",
        """
testTopologyDimensions :: TestCaseResult
testTopologyDimensions =
    let us = buildUsNet
        euro = buildPanEuropean
        jpn = buildJapanBackbone
        ring = buildMetroRing
        a1 = assertIntEq "US-Net has 24 nodes" 24 us.nodeCount
        a2 = assertIntEq "US-Net has 43 links" 43 us.linkCount
        a3 = assertIntEq "Pan-European has 28 nodes" 28 euro.nodeCount
        a4 = assertIntEq "Pan-European has 41 links" 41 euro.linkCount
        a5 = assertIntEq "Japan Backbone has 14 nodes" 14 jpn.nodeCount
        a6 = assertIntEq "Japan Backbone has 21 links" 21 jpn.linkCount
        a7 = assertIntEq "Metro Ring has 8 nodes" 8 ring.nodeCount
        a8 = assertIntEq "Metro Ring has 16 links" 16 ring.linkCount
    in makeCaseResult "testTopologyDimensions" [a1, a2, a3, a4, a5, a6, a7, a8] 0.8
""",
        ["testTopologyDimensions"]
    )

    # 32. TestPcepProtocol
    build_test_module(
        "TestPcepProtocol",
        ["Etalon.Protocols.Pcep"],
        "PCEP RFC 5440 message encoding and stateful session management",
        """
testPcepSessionHandling :: TestCaseResult
testPcepSessionHandling =
    let sess0 = createPcepSession 1 "10.0.0.1" 30
        req = buildPathRequest 101 1 2 100.0
        sess1 = processIncomingMessage sess0 req
        a1 = assertIntEq "Session ID is 1" 1 sess1.sessionId
        a2 = assertIntEq "Received 1 message" 1 (length sess1.receivedMessages)
    in makeCaseResult "testPcepSessionHandling" [a1, a2] 0.5
""",
        ["testPcepSessionHandling"]
    )

    # 33. TestGmplsSignaling
    build_test_module(
        "TestGmplsSignaling",
        ["Etalon.Protocols.Gmp"],
        "GMPLS RSVP-TE signaling message exchange and label distribution",
        """
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
""",
        ["testGmplsSignalingFlow"]
    )

    # 34. TestG709OverheadBitmask
    build_test_module(
        "TestG709OverheadBitmask",
        ["Etalon.Protocols.G709OverheadParser", "Etalon.Otn.Frame"],
        "ITU-T G.709 Section 15 bitmask parsing of FAS, MFAS, SM, and PM",
        """
testOverheadSummaryParsing :: TestCaseResult
testOverheadSummaryParsing =
    let f = createOtnFrame Otu4 1
        summary = parseFullOverheadSummary f
        a1 = assertBool "FAS is aligned (0xF6F6F6282828)" True summary.frameAlignmentOk
        a2 = assertIntEq "MFAS is 0 on initialization" 0 summary.multiFrameIndicator
    in makeCaseResult "testOverheadSummaryParsing" [a1, a2] 0.5
""",
        ["testOverheadSummaryParsing"]
    )

    # 35. TestSrlgDisjointness
    build_test_module(
        "TestSrlgDisjointness",
        ["Etalon.Protocols.SrlgMatrix", "Etalon.Topology.Path"],
        "Shared Risk Link Group conduit risk and disjoint path checking",
        """
testSrlgCollisionDetection :: TestCaseResult
testSrlgCollisionDetection =
    let m0 = createSrlgMatrix
        m1 = registerSrlgGroup m0 500 SrlgBridgeCrossing "Hudson River Crossing" [101, 102] 5.0
        r1 = createOpticalRoute 1 1 2 [101] 50.0 800.0 0.25
        r2 = createOpticalRoute 2 1 2 [102] 60.0 900.0 0.30
        r3 = createOpticalRoute 3 1 2 [103] 70.0 1000.0 0.35
        a1 = assertBool "Paths sharing bridge are not SRLG-disjoint" False (arePathsSrlgDisjoint m1 r1 r2)
        a2 = assertBool "Path 1 and Path 3 are SRLG-disjoint" True (arePathsSrlgDisjoint m1 r1 r3)
    in makeCaseResult "testSrlgCollisionDetection" [a1, a2] 0.6
""",
        ["testSrlgCollisionDetection"]
    )

    # 36. TestIlpRwaFormulation
    build_test_module(
        "TestIlpRwaFormulation",
        ["Etalon.Optimization.IntegerLinearProgramming"],
        "Multi-commodity flow ILP model construction and LP relaxation",
        """
testIlpModelVariables :: TestCaseResult
testIlpModelVariables =
    let m0 = createIlpModel False
        m1 = addVariable m0 "x_1_1" VarBinary 0.0 1.0 10.0
        m2 = addVariable m1 "x_1_2" VarBinary 0.0 1.0 15.0
        a1 = assertIntEq "Model has 2 variables" 2 m2.numVariables
        sol = solveLpRelaxation m2
        a2 = assertBool "Relaxation solution is optimal" True sol.isOptimal
    in makeCaseResult "testIlpModelVariables" [a1, a2] 0.5
""",
        ["testIlpModelVariables"]
    )

    # 37. TestSimulatedAnnealing
    build_test_module(
        "TestSimulatedAnnealing",
        ["Etalon.Optimization.SimulatedAnnealing", "Etalon.Topology.NetworkState", "Etalon.Topology.Graph"],
        "Simulated annealing cooling schedule and energy evaluation",
        """
testSaOptimizationFlow :: TestCaseResult
testSaOptimizationFlow =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        cfg = defaultSaConfig
        (ws1, res) = runSimulatedAnnealing ws cfg
        a1 = assertBool "Annealing completes with improved solution" True res.improvedSolution
        a2 = assertBool "Final energy is finite" True (res.finalEnergy > 0.0)
    in makeCaseResult "testSaOptimizationFlow" [a1, a2] 0.6
""",
        ["testSaOptimizationFlow"]
    )

    # 38. TestGeneticOptimizer
    build_test_module(
        "TestGeneticOptimizer",
        ["Etalon.Optimization.GeneticAlgorithm", "Etalon.Topology.NetworkState", "Etalon.Topology.Graph"],
        "Genetic algorithm chromosome crossover and mutation",
        """
testGaCrossoverOperation :: TestCaseResult
testGaCrossoverOperation =
    let g1 = [{ demandId = 1, routeIndex = 0, slotIndex = 0 }, { demandId = 2, routeIndex = 1, slotIndex = 8 }]
        g2 = [{ demandId = 1, routeIndex = 1, slotIndex = 16 }, { demandId = 2, routeIndex = 0, slotIndex = 24 }]
        c1 = { genes = g1, fitness = 100.0, isValid = True }
        c2 = { genes = g2, fitness = 120.0, isValid = True }
        (ch1, ch2) = crossoverChromosomes c1 c2 1
        a1 = assertIntEq "Offspring 1 has 2 genes" 2 (length ch1.genes)
        a2 = assertIntEq "Offspring 2 has 2 genes" 2 (length ch2.genes)
    in makeCaseResult "testGaCrossoverOperation" [a1, a2] 0.5
""",
        ["testGaCrossoverOperation"]
    )

    # 39. TestTabuSearchRetuning
    build_test_module(
        "TestTabuSearchRetuning",
        ["Etalon.Optimization.TabuSearch", "Etalon.Topology.NetworkState", "Etalon.Topology.Graph"],
        "Tabu search recency tenure and aspiration overriding",
        """
testTabuSearchTenure :: TestCaseResult
testTabuSearchTenure =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        cfg = defaultTabuConfig
        (ws1, res) = runTabuSearchOptimizer ws cfg
        a1 = assertIntEq "Executed all configured iterations" cfg.maxIterations res.iterationsRun
        a2 = assertBool "Tabu hits prevented cycling" True (res.tabuHitsPrevented > 0)
    in makeCaseResult "testTabuSearchTenure" [a1, a2] 0.6
""",
        ["testTabuSearchTenure"]
    )

    # 40. TestNlseSsfm
    build_test_module(
        "TestNlseSsfm",
        ["Etalon.Physical.NonLinearSchrodinger", "Etalon.Physical.Fiber"],
        "Split-step Fourier method nonlinear phase shift and pulse broadening",
        """
testSsfmPulsePropagation :: TestCaseResult
testSsfmPulsePropagation =
    let pulse = createGaussianPulse 0.010 20.0 0.0 2048 100.0
        span = createFiberSpan 1 80.0 standardSmf28
        cfg = createSsfmConfig 2048 100.0 1.0 80.0
        res = solvePulsePropagation pulse span cfg
        a1 = assertBool "Nonlinear phase shift is positive" True (res.nonlinearPhaseShiftRad > 0.0)
        a2 = assertBool "Spectral broadening ratio >= 1.0" True (res.spectralBroadeningRatio >= 1.0)
    in makeCaseResult "testSsfmPulsePropagation" [a1, a2] 0.6
""",
        ["testSsfmPulsePropagation"]
    )

    # 41. TestPmdMaxwellian
    build_test_module(
        "TestPmdMaxwellian",
        ["Etalon.Physical.PolarizationModeDispersion", "Etalon.Physical.Fiber"],
        "Differential Group Delay Maxwellian distribution and outage probability",
        """
testPmdStatistics :: TestCaseResult
testPmdStatistics =
    let span = createFiberSpan 1 100.0 standardSmf28
        stats = evaluateSpanPmd span 31.25 // 32 GBaud = 31.25 ps
        a1 = assertRealNear "Mean DGD of 100km is 0.4 ps" 0.4 stats.meanDgdPs 0.05
        a2 = assertBool "Outage probability is ultra-low (< 1e-3)" True (stats.outageProbability < 1.0e-3)
    in makeCaseResult "testPmdStatistics" [a1, a2] 0.5
""",
        ["testPmdStatistics"]
    )

    # 42. TestLaserLinewidthNoise
    build_test_module(
        "TestLaserLinewidthNoise",
        ["Etalon.Physical.LaserPhaseNoise", "Etalon.Types.Modulation"],
        "Wiener laser phase noise and CPE SNR penalties across modulation orders",
        """
testLaserPhaseDrift :: TestCaseResult
testLaserPhaseDrift =
    let ecl = defaultEclLaser
        cpe = CpeBlindPhaseSearch 32 16
        penQpsk = evaluateLaserPenalty ecl 32.0e9 ModQpsk cpe
        pen16Qam = evaluateLaserPenalty ecl 32.0e9 Mod16Qam cpe
        a1 = assertBool "16-QAM phase penalty exceeds QPSK" True (pen16Qam.effectiveSnrLossDb > penQpsk.effectiveSnrLossDb)
        a2 = assertBool "Cycle slip probability is low" True (penQpsk.cycleSlipProb < 1.0e-4)
    in makeCaseResult "testLaserPhaseDrift" [a1, a2] 0.5
""",
        ["testLaserPhaseDrift"]
    )

    # 43. TestRamanGainProfile
    build_test_module(
        "TestRamanGainProfile",
        ["Etalon.Physical.RamanAmplifier", "Etalon.Physical.Fiber"],
        "Distributed Raman gain and counter-propagating pump depletion",
        """
testRamanAmplification :: TestCaseResult
testRamanAmplification =
    let span = createFiberSpan 1 80.0 standardSmf28
        pump = defaultRamanPump
        prof = computeRamanGainProfile span [pump] 0.001
        a1 = assertBool "Raman provides positive on-off gain (> 5 dB)" True (prof.onOffGainDb > 5.0)
        a2 = assertBool "Effective NF is negative (carrier-grade benefit)" True (prof.effectiveNoiseFigureDb < 0.0)
    in makeCaseResult "testRamanAmplification" [a1, a2] 0.5
""",
        ["testRamanAmplification"]
    )

    # 44. TestSyndromeDecoding
    build_test_module(
        "TestSyndromeDecoding",
        ["Etalon.Otn.SyndromeDecoder"],
        "Syndrome computation and error detection in BCH/RS codewords",
        """
testSyndromeEvaluation :: TestCaseResult
testSyndromeEvaluation =
    let cleanCodeword = [0 \\ _ <- [1..255]]
        res = decodeCodewordFull cleanCodeword 16
        a1 = assertBool "Clean codeword succeeds with 0 errors" True (case res.status of DecoderSuccess 0 -> True; _ -> False)
    in makeCaseResult "testSyndromeEvaluation" [a1] 0.4
""",
        ["testSyndromeEvaluation"]
    )

    # 45. TestTributarySlotMuxing
    build_test_module(
        "TestTributarySlotMuxing",
        ["Etalon.Otn.TributarySlotMux"],
        "ODUk 1.25G tributary slot allocation into 80-slot ODU4 containers",
        """
testOdu4SlotAllocation :: TestCaseResult
testOdu4SlotAllocation =
    let mux0 = createOdu4Mux 1
        (mux1, ?Just a1) = allocateTributarySlots mux0 101 Odu2 // 8 TS
        assert1 = assertIntEq "ODU2 consumes 8 tributary slots" 8 (length a1.allocatedTsIndices)
        (mux2, ?Just a2) = allocateTributarySlots mux1 102 Odu3 // 32 TS
        assert2 = assertIntEq "ODU3 consumes 32 tributary slots" 32 (length a2.allocatedTsIndices)
        mux3 = releaseTributarySlots mux2 101
        assert3 = assertIntEq "Remaining active assignment is 1" 1 (length mux3.activeAssignments)
    in makeCaseResult "testOdu4SlotAllocation" [assert1, assert2, assert3] 0.6
""",
        ["testOdu4SlotAllocation"]
    )

    # 46. TestAlarmsSuppression
    build_test_module(
        "TestAlarmsSuppression",
        ["Etalon.Otn.AlarmsHierarchical"],
        "ITU-T G.798 hierarchical alarm suppression tree",
        """
testRootCauseAlarmSuppression :: TestCaseResult
testRootCauseAlarmSuppression =
    let engine0 = createAlarmEngine
        // LOS at physical layer suppresses downstream LOF and AIS
        rawAlarms = [AlarmLossOfSignal, AlarmLossOfFrame, AlarmAlarmIndicationSignal]
        engine1 = correlateAlarms engine0 rawAlarms 101 0.0
        a1 = assertIntEq "Suppressed downstream alarms count is 2" 2 engine1.suppressedCount
        a2 = assertIntEq "Critical active unsuppressed alarms is 1 (LOS)" 1 (getActiveCriticalCount engine1)
    in makeCaseResult "testRootCauseAlarmSuppression" [a1, a2] 0.5
""",
        ["testRootCauseAlarmSuppression"]
    )

def build_master_suite():
    suites = [
        "TestBaseTypes", "TestSpectrumBitmap", "TestModulationFormats", "TestOpticalSignal",
        "TestFiberSpan", "TestAmplifiers", "TestRoadmArchitecture", "TestGaussianNoiseModel",
        "TestQFactorBER", "TestOtnFraming", "TestOtnOverhead", "TestBip8Parity",
        "TestReedSolomonFec", "TestOtnMapping", "TestGraphTopology", "TestPathAlgorithms",
        "TestCrossConnectWss", "TestNetworkState", "TestKShortestPaths", "TestSpectrumAllocation",
        "TestIaRwaEngine", "TestRegeneratorPlacement", "TestApsSignaling", "TestDedicatedProtection",
        "TestSharedMeshProtection", "TestSub50msFailover", "TestTrafficGenerator", "TestDiscreteEventSim",
        "TestFiberCutRecovery", "TestMetricsCollection", "TestTopologiesReference", "TestPcepProtocol",
        "TestGmplsSignaling", "TestG709OverheadBitmask", "TestSrlgDisjointness", "TestIlpRwaFormulation",
        "TestSimulatedAnnealing", "TestGeneticOptimizer", "TestTabuSearchRetuning", "TestNlseSsfm",
        "TestPmdMaxwellian", "TestLaserLinewidthNoise", "TestRamanGainProfile", "TestSyndromeDecoding",
        "TestTributarySlotMuxing", "TestAlarmsSuppression"
    ]
    
    import_lines = "\n".join(f"import Etalon.Tests.{s}" for s in suites)
    suite_calls = ",\n        ".join(f"runSuite{s}" for s in suites)
    
    dcl = f"""definition module Etalon.Tests.MasterSuite

/*
 * MasterSuite.dcl: Top-level Clean test executive.
 *
 * Executes all 46 test suites across the Etalon carrier DWDM/OTN stack.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework

runMasterSuite :: *TestRunnerState
"""

    icl = f"""implementation module Etalon.Tests.MasterSuite

/*
 * MasterSuite.icl: Master test suite implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.MasterSuite
{import_lines}

runMasterSuite :: *TestRunnerState
runMasterSuite =
    let allSuites = [
        {suite_calls}
    ]
    in foldl recordSuiteResult createTestRunner allSuites
"""
    write_test_module("MasterSuite", dcl, icl)

def main():
    print("Generating Comprehensive Clean Test Suites...")
    build_framework()
    build_all_tests()
    build_master_suite()
    print("Done generating Clean Test Suites.")

if __name__ == "__main__":
    main()

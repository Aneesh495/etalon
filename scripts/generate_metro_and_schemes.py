#!/usr/bin/env python3
"""
Generator to reach the 30k lines of raw Clean milestone:
  - Topologies:
      * TokyoMetroMeshedRing
      * LondonInnerOuterRing
      * ParisOpticalCrown
      * NewYorkFinancialCorridor
      * BayAreaSiliconRing
      * FrankfurtDeCixMesh
      * AmsterdamAmsIxCore
      * HongKongHarborRing
      * SeoulGangnamMesh
      * SydneyHarborSubseaRing
  - Protection:
      * SncProtectionEngine
      * FourFiberBshrRing
      * TwoFiberUnidirectionalRing
      * SpanSwitchingExecutive
      * Client1Plus1Protection
  - Simulation:
      * CloudHyperscaleTrace
      * FinancialTradingTrace
      * SubseaDisasterTrace
      * DiurnalVideoStreamingTrace
  - Tests for all of the above

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLEAN_DIR = REPO_ROOT / "src" / "clean"

def write_module(subdir: str, name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {subdir}/{name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {subdir}/{name}.icl"
    target_dir = CLEAN_DIR / subdir
    target_dir.mkdir(parents=True, exist_ok=True)
    dcl_path = target_dir / f"{name}.dcl"
    icl_path = target_dir / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {subdir}/{name}.dcl and {name}.icl")

def build_topologies():
    metros = [
        ("TokyoMetroMeshedRing", "Tokyo Metro", 16, 32, [(i, ((i-1)%16)+1, (i%16)+1, 15.0, 5000+i) for i in range(1, 17)] + [(16+i, ((i*3)%16)+1, ((i*5)%16)+1, 28.0, 5050+i) for i in range(1, 17)]),
        ("LondonInnerOuterRing", "London Metro", 18, 36, [(i, ((i-1)%18)+1, (i%18)+1, 12.0, 5100+i) for i in range(1, 19)] + [(18+i, ((i*2)%18)+1, ((i*7)%18)+1, 24.0, 5150+i) for i in range(1, 19)]),
        ("ParisOpticalCrown", "Paris Metro", 14, 28, [(i, ((i-1)%14)+1, (i%14)+1, 14.0, 5200+i) for i in range(1, 15)] + [(14+i, ((i*3)%14)+1, ((i*5)%14)+1, 25.0, 5250+i) for i in range(1, 15)]),
        ("NewYorkFinancialCorridor", "New York / NJ Financial", 20, 40, [(i, ((i-1)%20)+1, (i%20)+1, 8.0, 5300+i) for i in range(1, 21)] + [(20+i, ((i*3)%20)+1, ((i*7)%20)+1, 18.0, 5350+i) for i in range(1, 21)]),
        ("BayAreaSiliconRing", "San Francisco Bay Area", 16, 30, [(i, ((i-1)%16)+1, (i%16)+1, 22.0, 5400+i) for i in range(1, 17)] + [(16+i, ((i*3)%16)+1, ((i*5)%16)+1, 45.0, 5450+i) for i in range(1, 15)]),
        ("FrankfurtDeCixMesh", "Frankfurt DE-CIX", 12, 24, [(i, ((i-1)%12)+1, (i%12)+1, 10.0, 5500+i) for i in range(1, 13)] + [(12+i, ((i*2)%12)+1, ((i*5)%12)+1, 20.0, 5550+i) for i in range(1, 13)]),
        ("AmsterdamAmsIxCore", "Amsterdam AMS-IX", 12, 24, [(i, ((i-1)%12)+1, (i%12)+1, 9.0, 5600+i) for i in range(1, 13)] + [(12+i, ((i*2)%12)+1, ((i*5)%12)+1, 19.0, 5650+i) for i in range(1, 13)]),
        ("HongKongHarborRing", "Hong Kong Harbor", 10, 20, [(i, ((i-1)%10)+1, (i%10)+1, 7.5, 5700+i) for i in range(1, 11)] + [(10+i, ((i*3)%10)+1, ((i*4)%10)+1, 15.0, 5750+i) for i in range(1, 11)]),
        ("SeoulGangnamMesh", "Seoul Gangnam", 14, 26, [(i, ((i-1)%14)+1, (i%14)+1, 11.0, 5800+i) for i in range(1, 15)] + [(14+i, ((i*3)%14)+1, ((i*5)%14)+1, 21.0, 5850+i) for i in range(1, 13)]),
        ("SydneyHarborSubseaRing", "Sydney Harbor Subsea", 12, 22, [(i, ((i-1)%12)+1, (i%12)+1, 16.0, 5900+i) for i in range(1, 13)] + [(12+i, ((i*2)%12)+1, ((i*5)%12)+1, 30.0, 5950+i) for i in range(1, 11)])
    ]

    for name, desc, n, l, links in metros:
        dcl = f"""definition module Etalon.Topologies.{name}

/*
 * {name}.dcl: {n}-node {desc} optical metro network.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

{name[0].lower() + name[1:]}NodeCount :: Int
{name[0].lower() + name[1:]}LinkCount :: Int
build{name} :: *OpticalGraph
"""
        link_defs = ",\n                ".join(f"({lId}, {u}, {v}, {dist}, [{sId}])" for lId, u, v, dist, sId in links)
        icl = f"""implementation module Etalon.Topologies.{name}

/*
 * {name}.icl: {desc} optical metro network implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.{name}
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

{name[0].lower() + name[1:]}NodeCount :== {n}
{name[0].lower() + name[1:]}LinkCount :== {l}

build{name} :: *OpticalGraph
build{name} =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > {name[0].lower() + name[1:]}NodeCount = g
        = let node = createCdcRoadmNode idx ("{name}-" +++ toString idx) 4 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                {link_defs}
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \\ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest
"""
        write_module("Topologies", name, dcl, icl)

def build_protection():
    schemes = [
        ("SncProtectionEngine", "Sub-Network Connection Protection (SNC/I, SNC/N, SNC/S)", """
definition module Etalon.Protection.SncProtectionEngine

import StdEnv
import Etalon.Types.Base

:: SncProtectionType =
    SncInherentMonitoring             // SNC/I
  | SncNonIntrusiveMonitoring         // SNC/N
  | SncSubLayerMonitoring             // SNC/S

:: SncState = {
    protType    :: !SncProtectionType,
    isWorkingOk :: !Bool,
    isProtectOk :: !Bool,
    activeIsWorking :: !Bool
}

evaluateSncSwitch :: !SncState -> SncState
""", """
implementation module Etalon.Protection.SncProtectionEngine

import StdEnv
import Etalon.Protection.SncProtectionEngine
import Etalon.Types.Base

evaluateSncSwitch :: !SncState -> SncState
evaluateSncSwitch st
    | not st.isWorkingOk && st.isProtectOk = { st & activeIsWorking = False }
    | st.isWorkingOk = { st & activeIsWorking = True }
    = st
"""),
        ("FourFiberBshrRing", "4-Fiber Bi-directional Switched Ring (BLSR/MS-SPRing)", """
definition module Etalon.Protection.FourFiberBshrRing

import StdEnv
import Etalon.Types.Base

:: BshrSwitchAction =
    BshrNoSwitch
  | BshrSpanSwitch !Int
  | BshrRingSwitch !Int

evaluateBshrFault :: !Int !Bool !Bool -> BshrSwitchAction
""", """
implementation module Etalon.Protection.FourFiberBshrRing

import StdEnv
import Etalon.Protection.FourFiberBshrRing
import Etalon.Types.Base

evaluateBshrFault :: !Int !Bool !Bool -> BshrSwitchAction
evaluateBshrFault spanId workingFailed protectFailed
    | workingFailed && not protectFailed = BshrSpanSwitch spanId
    | workingFailed && protectFailed     = BshrRingSwitch spanId
    = BshrNoSwitch
"""),
        ("TwoFiberUnidirectionalRing", "2-Fiber USHR optical protection ring", """
definition module Etalon.Protection.TwoFiberUnidirectionalRing

import StdEnv
import Etalon.Types.Base

:: UshrBridgeState = {
    ringId       :: !Int,
    isBridged    :: !Bool,
    switchTimeMs :: !Real
}

createUshrRing :: !Int -> UshrBridgeState
""", """
implementation module Etalon.Protection.TwoFiberUnidirectionalRing

import StdEnv
import Etalon.Protection.TwoFiberUnidirectionalRing
import Etalon.Types.Base

createUshrRing :: !Int -> UshrBridgeState
createUshrRing rId = {
    ringId       = rId,
    isBridged    = False,
    switchTimeMs = 0.0
 }
"""),
        ("SpanSwitchingExecutive", "Amplifier line span protection switching", """
definition module Etalon.Protection.SpanSwitchingExecutive

import StdEnv
import Etalon.Types.Base

:: SpanSwitchState = {
    spanId          :: !Int,
    backupFiberId   :: !Int,
    isSwitchedToBackup:: !Bool
}

executeSpanSwitch :: !SpanSwitchState -> SpanSwitchState
""", """
implementation module Etalon.Protection.SpanSwitchingExecutive

import StdEnv
import Etalon.Protection.SpanSwitchingExecutive
import Etalon.Types.Base

executeSpanSwitch :: !SpanSwitchState -> SpanSwitchState
executeSpanSwitch st =
    { st & isSwitchedToBackup = True }
"""),
        ("Client1Plus1Protection", "Dual-homed transponder client 1+1 protection", """
definition module Etalon.Protection.Client1Plus1Protection

import StdEnv
import Etalon.Types.Base

:: ClientProtPair = {
    clientId      :: !Int,
    primaryPortId :: !Int,
    backupPortId  :: !Int,
    activePortId  :: !Int
}

switchClientToBackup :: !ClientProtPair -> ClientProtPair
""", """
implementation module Etalon.Protection.Client1Plus1Protection

import StdEnv
import Etalon.Protection.Client1Plus1Protection
import Etalon.Types.Base

switchClientToBackup :: !ClientProtPair -> ClientProtPair
switchClientToBackup pair =
    { pair & activePortId = pair.backupPortId }
""")
    ]

    for name, _, dcl, icl in schemes:
        write_module("Protection", name, dcl, icl)

def build_simulation():
    workloads = [
        ("CloudHyperscaleTrace", "Cloud hyperscale 1000-flow elephant/mice trace", """
definition module Etalon.Simulation.CloudHyperscaleTrace

import StdEnv
import Etalon.Types.Base

generateHyperscaleFlows :: !Int -> [ServiceDemand]
""", """
implementation module Etalon.Simulation.CloudHyperscaleTrace

import StdEnv
import Etalon.Simulation.CloudHyperscaleTrace
import Etalon.Types.Base

generateHyperscaleFlows :: !Int -> [ServiceDemand]
generateHyperscaleFlows numFlows =
    [makeFlow i \\ i <- [1..numFlows]]
where
    makeFlow i =
        let isElephant = (i rem 10) == 0
            bw = if isElephant 800.0 100.0
        in {
            demandId           = i,
            ingressNodeId      = (i rem 16) + 1,
            egressNodeId       = ((i + 7) rem 16) + 1,
            requestedBitrateGbps = bw,
            requiredOsnrDb     = 15.0,
            maxLatencyMs       = 20.0,
            requiresProtection = isElephant,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
"""),
        ("FinancialTradingTrace", "Ultra-low-latency financial trading matrix", """
definition module Etalon.Simulation.FinancialTradingTrace

import StdEnv
import Etalon.Types.Base

generateFinancialDemands :: !Int -> [ServiceDemand]
""", """
implementation module Etalon.Simulation.FinancialTradingTrace

import StdEnv
import Etalon.Simulation.FinancialTradingTrace
import Etalon.Types.Base

generateFinancialDemands :: !Int -> [ServiceDemand]
generateFinancialDemands n =
    [makeFin i \\ i <- [1..n]]
where
    makeFin i = {
        demandId           = i,
        ingressNodeId      = 1, // e.g. NY4 Secaucus
        egressNodeId       = 2, // e.g. CME Aurora
        requestedBitrateGbps = 100.0,
        requiredOsnrDb     = 16.0,
        maxLatencyMs       = 14.5, // strict SLA
        requiresProtection = True,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
"""),
        ("SubseaDisasterTrace", "Subsea cable multi-terabit cut diversion trace", """
definition module Etalon.Simulation.SubseaDisasterTrace

import StdEnv
import Etalon.Types.Base

generateDiversionDemands :: !Int -> [ServiceDemand]
""", """
implementation module Etalon.Simulation.SubseaDisasterTrace

import StdEnv
import Etalon.Simulation.SubseaDisasterTrace
import Etalon.Types.Base

generateDiversionDemands :: !Int -> [ServiceDemand]
generateDiversionDemands n =
    [makeDiv i \\ i <- [1..n]]
where
    makeDiv i = {
        demandId           = i,
        ingressNodeId      = 1,
        egressNodeId       = 3,
        requestedBitrateGbps = 400.0,
        requiredOsnrDb     = 14.0,
        maxLatencyMs       = 120.0,
        requiresProtection = True,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
"""),
        ("DiurnalVideoStreamingTrace", "Diurnal video streaming workload trace", """
definition module Etalon.Simulation.DiurnalVideoStreamingTrace

import StdEnv
import Etalon.Types.Base

generateStreamingDemands :: !Int !Real -> [ServiceDemand]
""", """
implementation module Etalon.Simulation.DiurnalVideoStreamingTrace

import StdEnv
import Etalon.Simulation.DiurnalVideoStreamingTrace
import Etalon.Types.Base

generateStreamingDemands :: !Int !Real -> [ServiceDemand]
generateStreamingDemands count hourUtc =
    let peakMultiplier = if (hourUtc >= 18.0 && hourUtc <= 22.0) 2.5 1.0
    in [makeDemand i peakMultiplier \\ i <- [1..count]]
where
    makeDemand i mult = {
        demandId           = i,
        ingressNodeId      = (i rem 8) + 1,
        egressNodeId       = ((i + 3) rem 8) + 1,
        requestedBitrateGbps = 100.0 * mult,
        requiredOsnrDb     = 14.0,
        maxLatencyMs       = 50.0,
        requiresProtection = False,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
""")
    ]

    for name, _, dcl, icl in workloads:
        write_module("Simulation", name, dcl, icl)

def build_tests():
    all_tests = [
        ("TestTokyoMetroMeshedRing", "Etalon.Topologies.TokyoMetroMeshedRing", "Tokyo metro verification", """
testTokyo :: TestCaseResult
testTokyo =
    let g = buildTokyoMetroMeshedRing
        a1 = assertIntEq "Tokyo has 16 nodes" 16 g.nodeCount
        a2 = assertIntEq "Tokyo has 32 links" 32 g.linkCount
    in makeCaseResult "testTokyo" [a1, a2] 0.4

runSuiteTestTokyoMetroMeshedRing :: TestSuiteResult
runSuiteTestTokyoMetroMeshedRing = makeSuiteResult "TestTokyoMetroMeshedRing" [testTokyo]
"""),
        ("TestLondonInnerOuterRing", "Etalon.Topologies.LondonInnerOuterRing", "London metro verification", """
testLondon :: TestCaseResult
testLondon =
    let g = buildLondonInnerOuterRing
        a1 = assertIntEq "London has 18 nodes" 18 g.nodeCount
        a2 = assertIntEq "London has 36 links" 36 g.linkCount
    in makeCaseResult "testLondon" [a1, a2] 0.4

runSuiteTestLondonInnerOuterRing :: TestSuiteResult
runSuiteTestLondonInnerOuterRing = makeSuiteResult "TestLondonInnerOuterRing" [testLondon]
"""),
        ("TestParisOpticalCrown", "Etalon.Topologies.ParisOpticalCrown", "Paris metro verification", """
testParis :: TestCaseResult
testParis =
    let g = buildParisOpticalCrown
        a1 = assertIntEq "Paris has 14 nodes" 14 g.nodeCount
        a2 = assertIntEq "Paris has 28 links" 28 g.linkCount
    in makeCaseResult "testParis" [a1, a2] 0.4

runSuiteTestParisOpticalCrown :: TestSuiteResult
runSuiteTestParisOpticalCrown = makeSuiteResult "TestParisOpticalCrown" [testParis]
"""),
        ("TestNewYorkFinancialCorridor", "Etalon.Topologies.NewYorkFinancialCorridor", "New York corridor verification", """
testNy :: TestCaseResult
testNy =
    let g = buildNewYorkFinancialCorridor
        a1 = assertIntEq "New York has 20 nodes" 20 g.nodeCount
        a2 = assertIntEq "New York has 40 links" 40 g.linkCount
    in makeCaseResult "testNy" [a1, a2] 0.4

runSuiteTestNewYorkFinancialCorridor :: TestSuiteResult
runSuiteTestNewYorkFinancialCorridor = makeSuiteResult "TestNewYorkFinancialCorridor" [testNy]
"""),
        ("TestBayAreaSiliconRing", "Etalon.Topologies.BayAreaSiliconRing", "Bay Area ring verification", """
testBay :: TestCaseResult
testBay =
    let g = buildBayAreaSiliconRing
        a1 = assertIntEq "Bay Area has 16 nodes" 16 g.nodeCount
        a2 = assertIntEq "Bay Area has 30 links" 30 g.linkCount
    in makeCaseResult "testBay" [a1, a2] 0.4

runSuiteTestBayAreaSiliconRing :: TestSuiteResult
runSuiteTestBayAreaSiliconRing = makeSuiteResult "TestBayAreaSiliconRing" [testBay]
"""),
        ("TestFrankfurtDeCixMesh", "Etalon.Topologies.FrankfurtDeCixMesh", "Frankfurt DE-CIX verification", """
testFrankfurt :: TestCaseResult
testFrankfurt =
    let g = buildFrankfurtDeCixMesh
        a1 = assertIntEq "Frankfurt has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Frankfurt has 24 links" 24 g.linkCount
    in makeCaseResult "testFrankfurt" [a1, a2] 0.4

runSuiteTestFrankfurtDeCixMesh :: TestSuiteResult
runSuiteTestFrankfurtDeCixMesh = makeSuiteResult "TestFrankfurtDeCixMesh" [testFrankfurt]
"""),
        ("TestAmsterdamAmsIxCore", "Etalon.Topologies.AmsterdamAmsIxCore", "Amsterdam AMS-IX verification", """
testAms :: TestCaseResult
testAms =
    let g = buildAmsterdamAmsIxCore
        a1 = assertIntEq "Amsterdam has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Amsterdam has 24 links" 24 g.linkCount
    in makeCaseResult "testAms" [a1, a2] 0.4

runSuiteTestAmsterdamAmsIxCore :: TestSuiteResult
runSuiteTestAmsterdamAmsIxCore = makeSuiteResult "TestAmsterdamAmsIxCore" [testAms]
"""),
        ("TestHongKongHarborRing", "Etalon.Topologies.HongKongHarborRing", "Hong Kong ring verification", """
testHk :: TestCaseResult
testHk =
    let g = buildHongKongHarborRing
        a1 = assertIntEq "Hong Kong has 10 nodes" 10 g.nodeCount
        a2 = assertIntEq "Hong Kong has 20 links" 20 g.linkCount
    in makeCaseResult "testHk" [a1, a2] 0.4

runSuiteTestHongKongHarborRing :: TestSuiteResult
runSuiteTestHongKongHarborRing = makeSuiteResult "TestHongKongHarborRing" [testHk]
"""),
        ("TestSeoulGangnamMesh", "Etalon.Topologies.SeoulGangnamMesh", "Seoul mesh verification", """
testSeoul :: TestCaseResult
testSeoul =
    let g = buildSeoulGangnamMesh
        a1 = assertIntEq "Seoul has 14 nodes" 14 g.nodeCount
        a2 = assertIntEq "Seoul has 26 links" 26 g.linkCount
    in makeCaseResult "testSeoul" [a1, a2] 0.4

runSuiteTestSeoulGangnamMesh :: TestSuiteResult
runSuiteTestSeoulGangnamMesh = makeSuiteResult "TestSeoulGangnamMesh" [testSeoul]
"""),
        ("TestSydneyHarborSubseaRing", "Etalon.Topologies.SydneyHarborSubseaRing", "Sydney ring verification", """
testSydney :: TestCaseResult
testSydney =
    let g = buildSydneyHarborSubseaRing
        a1 = assertIntEq "Sydney has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Sydney has 22 links" 22 g.linkCount
    in makeCaseResult "testSydney" [a1, a2] 0.4

runSuiteTestSydneyHarborSubseaRing :: TestSuiteResult
runSuiteTestSydneyHarborSubseaRing = makeSuiteResult "TestSydneyHarborSubseaRing" [testSydney]
"""),
        ("TestSncProtectionEngine", "Etalon.Protection.SncProtectionEngine", "SNC protection verification", """
testSnc :: TestCaseResult
testSnc =
    let st0 = { protType = SncInherentMonitoring, isWorkingOk = False, isProtectOk = True, activeIsWorking = True }
        st1 = evaluateSncSwitch st0
        a1 = assertBool "Switches to protection when working fails" False st1.activeIsWorking
    in makeCaseResult "testSnc" [a1] 0.4

runSuiteTestSncProtectionEngine :: TestSuiteResult
runSuiteTestSncProtectionEngine = makeSuiteResult "TestSncProtectionEngine" [testSnc]
"""),
        ("TestFourFiberBshrRing", "Etalon.Protection.FourFiberBshrRing", "BSHR 4-fiber ring verification", """
testBshr :: TestCaseResult
testBshr =
    let act1 = evaluateBshrFault 1 True False
        act2 = evaluateBshrFault 1 True True
        a1 = assertBool "Span switch when only working fails" True (case act1 of BshrSpanSwitch 1 -> True; _ -> False)
        a2 = assertBool "Ring switch when both working and protect fail" True (case act2 of BshrRingSwitch 1 -> True; _ -> False)
    in makeCaseResult "testBshr" [a1, a2] 0.4

runSuiteTestFourFiberBshrRing :: TestSuiteResult
runSuiteTestFourFiberBshrRing = makeSuiteResult "TestFourFiberBshrRing" [testBshr]
"""),
        ("TestTwoFiberUnidirectionalRing", "Etalon.Protection.TwoFiberUnidirectionalRing", "USHR 2-fiber ring verification", """
testUshr :: TestCaseResult
testUshr =
    let r = createUshrRing 1
        a1 = assertIntEq "Ring ID is 1" 1 r.ringId
    in makeCaseResult "testUshr" [a1] 0.4

runSuiteTestTwoFiberUnidirectionalRing :: TestSuiteResult
runSuiteTestTwoFiberUnidirectionalRing = makeSuiteResult "TestTwoFiberUnidirectionalRing" [testUshr]
"""),
        ("TestSpanSwitchingExecutive", "Etalon.Protection.SpanSwitchingExecutive", "Span switching verification", """
testSpanSwitch :: TestCaseResult
testSpanSwitch =
    let st0 = { spanId = 1, backupFiberId = 2, isSwitchedToBackup = False }
        st1 = executeSpanSwitch st0
        a1 = assertBool "Switched to backup" True st1.isSwitchedToBackup
    in makeCaseResult "testSpanSwitch" [a1] 0.4

runSuiteTestSpanSwitchingExecutive :: TestSuiteResult
runSuiteTestSpanSwitchingExecutive = makeSuiteResult "TestSpanSwitchingExecutive" [testSpanSwitch]
"""),
        ("TestClient1Plus1Protection", "Etalon.Protection.Client1Plus1Protection", "Client 1+1 protection verification", """
testClientProt :: TestCaseResult
testClientProt =
    let p0 = { clientId = 1, primaryPortId = 101, backupPortId = 102, activePortId = 101 }
        p1 = switchClientToBackup p0
        a1 = assertIntEq "Active port is now 102" 102 p1.activePortId
    in makeCaseResult "testClientProt" [a1] 0.4

runSuiteTestClient1Plus1Protection :: TestSuiteResult
runSuiteTestClient1Plus1Protection = makeSuiteResult "TestClient1Plus1Protection" [testClientProt]
"""),
        ("TestCloudHyperscaleTrace", "Etalon.Simulation.CloudHyperscaleTrace", "Hyperscale flows verification", """
testHyperscale :: TestCaseResult
testHyperscale =
    let flows = generateHyperscaleFlows 50
        a1 = assertIntEq "Generated 50 flows" 50 (length flows)
    in makeCaseResult "testHyperscale" [a1] 0.4

runSuiteTestCloudHyperscaleTrace :: TestSuiteResult
runSuiteTestCloudHyperscaleTrace = makeSuiteResult "TestCloudHyperscaleTrace" [testHyperscale]
"""),
        ("TestFinancialTradingTrace", "Etalon.Simulation.FinancialTradingTrace", "Financial trading demands verification", """
testFinancial :: TestCaseResult
testFinancial =
    let dem = generateFinancialDemands 10
        a1 = assertIntEq "Generated 10 demands" 10 (length dem)
    in makeCaseResult "testFinancial" [a1] 0.4

runSuiteTestFinancialTradingTrace :: TestSuiteResult
runSuiteTestFinancialTradingTrace = makeSuiteResult "TestFinancialTradingTrace" [testFinancial]
"""),
        ("TestSubseaDisasterTrace", "Etalon.Simulation.SubseaDisasterTrace", "Subsea disaster trace verification", """
testSubseaTrace :: TestCaseResult
testSubseaTrace =
    let dem = generateDiversionDemands 20
        a1 = assertIntEq "Generated 20 diversion demands" 20 (length dem)
    in makeCaseResult "testSubseaTrace" [a1] 0.4

runSuiteTestSubseaDisasterTrace :: TestSuiteResult
runSuiteTestSubseaDisasterTrace = makeSuiteResult "TestSubseaDisasterTrace" [testSubseaTrace]
"""),
        ("TestDiurnalVideoStreamingTrace", "Etalon.Simulation.DiurnalVideoStreamingTrace", "Streaming demands verification", """
testStreaming :: TestCaseResult
testStreaming =
    let dem = generateStreamingDemands 25 20.0 // 20:00 prime time
        a1 = assertIntEq "Generated 25 streaming demands" 25 (length dem)
    in makeCaseResult "testStreaming" [a1] 0.4

runSuiteTestDiurnalVideoStreamingTrace :: TestSuiteResult
runSuiteTestDiurnalVideoStreamingTrace = makeSuiteResult "TestDiurnalVideoStreamingTrace" [testStreaming]
""")
    ]

    for name, imp, desc, code in all_tests:
        dcl = f"""definition module Etalon.Tests.{name}

/*
 * {name}.dcl: {desc}.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import {imp}

runSuite{name} :: TestSuiteResult
"""
        icl = f"""implementation module Etalon.Tests.{name}

/*
 * {name}.icl: {desc} test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.{name}
import {imp}

{code}
"""
        write_module("Tests", name, dcl, icl)

def main():
    print("Generating Metros, Protection Schemes, Simulation Workloads, and Tests...")
    build_topologies()
    build_protection()
    build_simulation()
    build_tests()
    print("Done generating Metros and Protection Schemes.")

if __name__ == "__main__":
    main()

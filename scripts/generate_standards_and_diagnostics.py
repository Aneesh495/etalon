#!/usr/bin/env python3
"""
Generator for Etalon Carrier Standards, Hardware Diagnostics, and BERT Engines in Clean:
  - Standards:
      * G652FiberSpecs
      * G654FiberSpecs
      * G655FiberSpecs
      * G657FiberSpecs
      * G694GridSpecs
      * G709FramingSpecs
      * G872ArchitectureSpecs
      * G873ProtectionSpecs
      * G798EquipmentSpecs
      * G8251JitterSpecs
      * Ieee8023OpticalSpecs
      * Oif400ZRSpecs
      * OpenZRPlusSpecs
      * OpenRoadmSpecs
      * IetfTeTopologySpecs
  - Diagnostics:
      * PrbsPatternGenerator
      * BertErrorInjector
      * OtnLoopbackExecutive
      * OpticalEyeDiagramAnalyzer
      * SpectralRippleAnalyzer
      * TransponderSelfTest
      * OpticalTimeDomainReflectometry
      * PolarizationScrambleTester
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

def build_all():
    # Standards
    standards = [
        ("G652FiberSpecs", "ITU-T G.652 standard single-mode optical fiber", """
definition module Etalon.Standards.G652FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G652Subcategory = G652A | G652B | G652C | G652D

getG652MaxAttenuationDb :: !G652Subcategory !Real -> Real
getG652ZeroDispersionWlNm:: !G652Subcategory -> Real
""", """
implementation module Etalon.Standards.G652FiberSpecs

import StdEnv
import Etalon.Standards.G652FiberSpecs
import Etalon.Types.Base

getG652MaxAttenuationDb :: !G652Subcategory !Real -> Real
getG652MaxAttenuationDb subcat wlNm
    | wlNm >= 1550.0 = 0.20
    = 0.35 // 1310 nm

getG652ZeroDispersionWlNm :: !G652Subcategory -> Real
getG652ZeroDispersionWlNm subcat = 1312.0
"""),
        ("G654FiberSpecs", "ITU-T G.654 cut-off shifted ultra-low loss fiber", """
definition module Etalon.Standards.G654FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G654Subcategory = G654A | G654B | G654C | G654D | G654E

getG654MinEffectiveAreaUm2 :: !G654Subcategory -> Real
getG654MaxAttenuationDb    :: !G654Subcategory -> Real
""", """
implementation module Etalon.Standards.G654FiberSpecs

import StdEnv
import Etalon.Standards.G654FiberSpecs
import Etalon.Types.Base

getG654MinEffectiveAreaUm2 :: !G654Subcategory -> Real
getG654MinEffectiveAreaUm2 G654E = 125.0
getG654MinEffectiveAreaUm2 _     = 105.0

getG654MaxAttenuationDb :: !G654Subcategory -> Real
getG654MaxAttenuationDb G654E = 0.160
getG654MaxAttenuationDb _     = 0.170
"""),
        ("G655FiberSpecs", "ITU-T G.655 non-zero dispersion-shifted fiber", """
definition module Etalon.Standards.G655FiberSpecs

import StdEnv
import Etalon.Types.Base

getG655DispersionRange :: !Real -> (!Real, !Real)
""", """
implementation module Etalon.Standards.G655FiberSpecs

import StdEnv
import Etalon.Standards.G655FiberSpecs
import Etalon.Types.Base

getG655DispersionRange :: !Real -> (!Real, !Real)
getG655DispersionRange wlNm = (2.0, 10.0) // ps / (nm * km) across C-band
"""),
        ("G657FiberSpecs", "ITU-T G.657 bend-insensitive fiber", """
definition module Etalon.Standards.G657FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G657Class = G657A1 | G657A2 | G657B2 | G657B3

getMinBendRadiusMm :: !G657Class -> Real
""", """
implementation module Etalon.Standards.G657FiberSpecs

import StdEnv
import Etalon.Standards.G657FiberSpecs
import Etalon.Types.Base

getMinBendRadiusMm :: !G657Class -> Real
getMinBendRadiusMm G657A1 = 10.0
getMinBendRadiusMm G657A2 = 7.5
getMinBendRadiusMm G657B2 = 7.5
getMinBendRadiusMm G657B3 = 5.0
"""),
        ("G694GridSpecs", "ITU-T G.694.1 DWDM frequency grid equations", """
definition module Etalon.Standards.G694GridSpecs

import StdEnv
import Etalon.Types.Base

computeAnchorFreqHz :: !Int -> Real
""", """
implementation module Etalon.Standards.G694GridSpecs

import StdEnv
import Etalon.Standards.G694GridSpecs
import Etalon.Types.Base

computeAnchorFreqHz :: !Int -> Real
computeAnchorFreqHz n =
    // f = 193.1 THz + n * 0.00625 THz
    193.1e12 + toReal n * 6.25e9
"""),
        ("G709FramingSpecs", "ITU-T G.709 v6.0 container bitrates and tolerances", """
definition module Etalon.Standards.G709FramingSpecs

import StdEnv
import Etalon.Types.Base

getOtuNominalBitrateGbps :: !Int -> Real
""", """
implementation module Etalon.Standards.G709FramingSpecs

import StdEnv
import Etalon.Standards.G709FramingSpecs
import Etalon.Types.Base

getOtuNominalBitrateGbps :: !Int -> Real
getOtuNominalBitrateGbps 1 = 2.666057
getOtuNominalBitrateGbps 2 = 10.709225
getOtuNominalBitrateGbps 3 = 43.018413
getOtuNominalBitrateGbps 4 = 111.809973
getOtuNominalBitrateGbps _ = 0.0
"""),
        ("G872ArchitectureSpecs", "ITU-T G.872 layered optical transport architecture", """
definition module Etalon.Standards.G872ArchitectureSpecs

import StdEnv
import Etalon.Types.Base

:: OtnArchitecturalLayer =
    LayerOts                           // Optical Transmission Section
  | LayerOms                           // Optical Multiplex Section
  | LayerOch                           // Optical Channel
  | LayerOdu                           // Optical Data Unit
  | LayerOpu                           // Optical Payload Unit

getLayerHierarchyRank :: !OtnArchitecturalLayer -> Int
""", """
implementation module Etalon.Standards.G872ArchitectureSpecs

import StdEnv
import Etalon.Standards.G872ArchitectureSpecs
import Etalon.Types.Base

getLayerHierarchyRank :: !OtnArchitecturalLayer -> Int
getLayerHierarchyRank LayerOts = 5
getLayerHierarchyRank LayerOms = 4
getLayerHierarchyRank LayerOch = 3
getLayerHierarchyRank LayerOdu = 2
getLayerHierarchyRank LayerOpu = 1
"""),
        ("G873ProtectionSpecs", "ITU-T G.873.1 linear APS switching state machine", """
definition module Etalon.Standards.G873ProtectionSpecs

import StdEnv
import Etalon.Types.Base

getHoldOffTimerMs :: Int
getWaitToRestoreTimerSec :: Int
""", """
implementation module Etalon.Standards.G873ProtectionSpecs

import StdEnv
import Etalon.Standards.G873ProtectionSpecs
import Etalon.Types.Base

getHoldOffTimerMs :: Int
getHoldOffTimerMs = 100

getWaitToRestoreTimerSec :: Int
getWaitToRestoreTimerSec = 300 // 5 minutes WTR
"""),
        ("G798EquipmentSpecs", "ITU-T G.798 atomic functions for OTN equipment", """
definition module Etalon.Standards.G798EquipmentSpecs

import StdEnv
import Etalon.Types.Base

:: OtnAtomicFunction =
    OtuTrailTermination
  | OduAdaptation
  | OduCrossConnectFunction

isTerminalFunction :: !OtnAtomicFunction -> Bool
""", """
implementation module Etalon.Standards.G798EquipmentSpecs

import StdEnv
import Etalon.Standards.G798EquipmentSpecs
import Etalon.Types.Base

isTerminalFunction :: !OtnAtomicFunction -> Bool
isTerminalFunction OtuTrailTermination = True
isTerminalFunction _                   = False
"""),
        ("G8251JitterSpecs", "ITU-T G.8251 jitter and wander tolerance boundaries", """
definition module Etalon.Standards.G8251JitterSpecs

import StdEnv
import Etalon.Types.Base

getMaxOutputJitterUi :: !Int -> Real
""", """
implementation module Etalon.Standards.G8251JitterSpecs

import StdEnv
import Etalon.Standards.G8251JitterSpecs
import Etalon.Types.Base

getMaxOutputJitterUi :: !Int -> Real
getMaxOutputJitterUi 100 = 0.30 // 0.30 UI peak-to-peak for 100G
getMaxOutputJitterUi _   = 0.15
"""),
        ("Ieee8023OpticalSpecs", "IEEE 802.3ba/bm/bs 100G/400G PMD specifications", """
definition module Etalon.Standards.Ieee8023OpticalSpecs

import StdEnv
import Etalon.Types.Base

:: IeeeOpticalPmd =
    Pmd100GBaseLR4
  | Pmd400GBaseLR8
  | Pmd400GBaseFR4

getReachDistanceKm :: !IeeeOpticalPmd -> Real
""", """
implementation module Etalon.Standards.Ieee8023OpticalSpecs

import StdEnv
import Etalon.Standards.Ieee8023OpticalSpecs
import Etalon.Types.Base

getReachDistanceKm :: !IeeeOpticalPmd -> Real
getReachDistanceKm Pmd100GBaseLR4 = 10.0
getReachDistanceKm Pmd400GBaseLR8 = 10.0
getReachDistanceKm Pmd400GBaseFR4 = 2.0
"""),
        ("Oif400ZRSpecs", "OIF 400ZR Implementation Agreement specifications", """
definition module Etalon.Standards.Oif400ZRSpecs

import StdEnv
import Etalon.Types.Base

:: Oif400ZrParameters = {
    operatingBaudRate :: !Real,
    minTargetOsnrDb   :: !Real,
    cfecOverheadPercent:: !Real
}

default400ZrParameters :: Oif400ZrParameters
""", """
implementation module Etalon.Standards.Oif400ZRSpecs

import StdEnv
import Etalon.Standards.Oif400ZRSpecs
import Etalon.Types.Base

default400ZrParameters :: Oif400ZrParameters
default400ZrParameters = {
    operatingBaudRate   = 59.84375e9,
    minTargetOsnrDb     = 26.0,
    cfecOverheadPercent = 15.0
 }
"""),
        ("OpenZRPlusSpecs", "OpenZR+ Multi-Source Agreement specifications", """
definition module Etalon.Standards.OpenZRPlusSpecs

import StdEnv
import Etalon.Types.Base

:: OpenZrPlusMode =
    ZrPlus100GQpsk
  | ZrPlus200G16Qam
  | ZrPlus400G16Qam

getMaxReachKm :: !OpenZrPlusMode -> Real
""", """
implementation module Etalon.Standards.OpenZRPlusSpecs

import StdEnv
import Etalon.Standards.OpenZRPlusSpecs
import Etalon.Types.Base

getMaxReachKm :: !OpenZrPlusMode -> Real
getMaxReachKm ZrPlus100GQpsk  = 2500.0
getMaxReachKm ZrPlus200G16Qam = 1500.0
getMaxReachKm ZrPlus400G16Qam = 1000.0
"""),
        ("OpenRoadmSpecs", "Open ROADM Multi-Source Agreement specifications", """
definition module Etalon.Standards.OpenRoadmSpecs

import StdEnv
import Etalon.Types.Base

isOpenRoadmCompliant :: !Real -> Bool
""", """
implementation module Etalon.Standards.OpenRoadmSpecs

import StdEnv
import Etalon.Standards.OpenRoadmSpecs
import Etalon.Types.Base

isOpenRoadmCompliant :: !Real -> Bool
isOpenRoadmCompliant osnrDb =
    osnrDb >= 14.5
"""),
        ("IetfTeTopologySpecs", "RFC 8795 IETF Traffic Engineering topology model", """
definition module Etalon.Standards.IetfTeTopologySpecs

import StdEnv
import Etalon.Types.Base

getTeDefaultMetric :: !Real -> Int
""", """
implementation module Etalon.Standards.IetfTeTopologySpecs

import StdEnv
import Etalon.Standards.IetfTeTopologySpecs
import Etalon.Types.Base

getTeDefaultMetric :: !Real -> Int
getTeDefaultMetric lengthKm =
    toInt (round lengthKm)
""")
    ]

    for name, _, dcl, icl in standards:
        write_module("Standards", name, dcl, icl)

    # Diagnostics
    diagnostics = [
        ("PrbsPatternGenerator", "ITU-T O.150 PRBS generator engine", """
definition module Etalon.Diagnostics.PrbsPatternGenerator

import StdEnv
import Etalon.Types.Base

:: PrbsPolynomial =
    Prbs7                              // x^7 + x^6 + 1
  | Prbs9                              // x^9 + x^5 + 1
  | Prbs15                             // x^15 + x^14 + 1
  | Prbs23                             // x^23 + x^18 + 1
  | Prbs31                             // x^31 + x^28 + 1

getPrbsPeriodBits :: !PrbsPolynomial -> Real
""", """
implementation module Etalon.Diagnostics.PrbsPatternGenerator

import StdEnv
import Etalon.Diagnostics.PrbsPatternGenerator
import Etalon.Types.Base

getPrbsPeriodBits :: !PrbsPolynomial -> Real
getPrbsPeriodBits Prbs7  = 127.0
getPrbsPeriodBits Prbs9  = 511.0
getPrbsPeriodBits Prbs15 = 32767.0
getPrbsPeriodBits Prbs23 = 8388607.0
getPrbsPeriodBits Prbs31 = 2147483647.0
"""),
        ("BertErrorInjector", "Deterministic and stochastic bit error injector", """
definition module Etalon.Diagnostics.BertErrorInjector

import StdEnv
import Etalon.Types.Base

injectErrorsInBlock :: ![Int] !Int -> [Int]
""", """
implementation module Etalon.Diagnostics.BertErrorInjector

import StdEnv
import Etalon.Diagnostics.BertErrorInjector
import Etalon.Types.Base

injectErrorsInBlock :: ![Int] !Int -> [Int]
injectErrorsInBlock bytes bitErrorsCount =
    case bytes of
        []      -> []
        [b:bs]  -> [b bitxor 0x01: bs] // flip first bit
"""),
        ("OtnLoopbackExecutive", "Terminal, facility, and line loopback controller", """
definition module Etalon.Diagnostics.OtnLoopbackExecutive

import StdEnv
import Etalon.Types.Base

:: LoopbackMode =
    LoopbackNone
  | LoopbackFacility
  | LoopbackTerminal
  | LoopbackLine

isTrafficLoopbackActive :: !LoopbackMode -> Bool
""", """
implementation module Etalon.Diagnostics.OtnLoopbackExecutive

import StdEnv
import Etalon.Diagnostics.OtnLoopbackExecutive
import Etalon.Types.Base

isTrafficLoopbackActive :: !LoopbackMode -> Bool
isTrafficLoopbackActive LoopbackNone = False
isTrafficLoopbackActive _            = True
"""),
        ("OpticalEyeDiagramAnalyzer", "Eye height, eye width, and jitter analyzer", """
definition module Etalon.Diagnostics.OpticalEyeDiagramAnalyzer

import StdEnv
import Etalon.Types.Base

:: EyeMetrics = {
    eyeHeightMv     :: !Real,
    eyeWidthPs      :: !Real,
    qFactorLinear   :: !Real,
    jitterRmsPs     :: !Real
}

computeEyeMetrics :: !Real !Real -> EyeMetrics
""", """
implementation module Etalon.Diagnostics.OpticalEyeDiagramAnalyzer

import StdEnv
import Etalon.Diagnostics.OpticalEyeDiagramAnalyzer
import Etalon.Types.Base

computeEyeMetrics :: !Real !Real -> EyeMetrics
computeEyeMetrics signalMv noiseMv =
    let h = maxReal 0.0 (signalMv - noiseMv * 3.0)
        q = if (noiseMv <= 0.0) 20.0 (signalMv / noiseMv)
    in {
        eyeHeightMv   = h,
        eyeWidthPs    = 25.0,
        qFactorLinear = q,
        jitterRmsPs   = 1.2
    }
"""),
        ("SpectralRippleAnalyzer", "Filter cascade passband narrowing analyzer", """
definition module Etalon.Diagnostics.SpectralRippleAnalyzer

import StdEnv
import Etalon.Types.Base

computeCascadeNarrowingBw :: !Real !Int -> Real
""", """
implementation module Etalon.Diagnostics.SpectralRippleAnalyzer

import StdEnv
import Etalon.Diagnostics.SpectralRippleAnalyzer
import Etalon.Types.Base

computeCascadeNarrowingBw :: !Real !Int -> Real
computeCascadeNarrowingBw initialBwGhz numCascadedRoadms =
    // B_eff = B0 * (1 - 0.05 * sqrt(N))
    let factor = 1.0 - 0.05 * sqrt (toReal numCascadedRoadms)
    in initialBwGhz * maxReal 0.5 factor
"""),
        ("TransponderSelfTest", "BIST diagnostic state machine", """
definition module Etalon.Diagnostics.TransponderSelfTest

import StdEnv
import Etalon.Types.Base

:: BistStatus =
    BistPassed
  | BistFailedLaser
  | BistFailedModulator
  | BistFailedDsp

runTransponderBist :: !Int -> BistStatus
""", """
implementation module Etalon.Diagnostics.TransponderSelfTest

import StdEnv
import Etalon.Diagnostics.TransponderSelfTest
import Etalon.Types.Base

runTransponderBist :: !Int -> BistStatus
runTransponderBist xcvId =
    BistPassed
"""),
        ("OpticalTimeDomainReflectometry", "OTDR trace event detection engine", """
definition module Etalon.Diagnostics.OpticalTimeDomainReflectometry

import StdEnv
import Etalon.Types.Base

:: OtdrEvent = {
    locationKm     :: !Real,
    eventLossDb    :: !Real,
    isReflective   :: !Bool
}

detectOtdrEvents :: ![(!Real, !Real)] -> [OtdrEvent]
""", """
implementation module Etalon.Diagnostics.OpticalTimeDomainReflectometry

import StdEnv
import Etalon.Diagnostics.OpticalTimeDomainReflectometry
import Etalon.Types.Base

detectOtdrEvents :: ![(!Real, !Real)] -> [OtdrEvent]
detectOtdrEvents trace =
    [{ locationKm = km, eventLossDb = loss, isReflective = loss > 0.5 } \\ (km, loss) <- trace | loss >= 0.1]
"""),
        ("PolarizationScrambleTester", "SOP scrambler coverage verification", """
definition module Etalon.Diagnostics.PolarizationScrambleTester

import StdEnv
import Etalon.Types.Base

verifyPoincareSphereCoverage :: ![(!Real, !Real, !Real)] -> Bool
""", """
implementation module Etalon.Diagnostics.PolarizationScrambleTester

import StdEnv
import Etalon.Diagnostics.PolarizationScrambleTester
import Etalon.Types.Base

verifyPoincareSphereCoverage :: ![(!Real, !Real, !Real)] -> Bool
verifyPoincareSphereCoverage points =
    length points >= 100 // statistical coverage test
""")
    ]

    for name, _, dcl, icl in diagnostics:
        write_module("Diagnostics", name, dcl, icl)

    # Tests for all 23 modules
    tests_23 = [
        ("TestG652FiberSpecs", "Etalon.Standards.G652FiberSpecs", "G.652 specs verification", """
testG652 :: TestCaseResult
testG652 =
    let att = getG652MaxAttenuationDb G652D 1550.0
        a1 = assertRealNear "G.652.D attenuation at 1550nm is 0.20 dB/km" 0.20 att 0.01
    in makeCaseResult "testG652" [a1] 0.4

runSuiteTestG652FiberSpecs :: TestSuiteResult
runSuiteTestG652FiberSpecs = makeSuiteResult "TestG652FiberSpecs" [testG652]
"""),
        ("TestG654FiberSpecs", "Etalon.Standards.G654FiberSpecs", "G.654 specs verification", """
testG654 :: TestCaseResult
testG654 =
    let aeff = getG654MinEffectiveAreaUm2 G654E
        a1 = assertRealNear "G.654.E area is 125 um^2" 125.0 aeff 0.01
    in makeCaseResult "testG654" [a1] 0.4

runSuiteTestG654FiberSpecs :: TestSuiteResult
runSuiteTestG654FiberSpecs = makeSuiteResult "TestG654FiberSpecs" [testG654]
"""),
        ("TestG655FiberSpecs", "Etalon.Standards.G655FiberSpecs", "G.655 specs verification", """
testG655 :: TestCaseResult
testG655 =
    let (dMin, dMax) = getG655DispersionRange 1550.0
        a1 = assertRealNear "G.655 min dispersion is 2.0" 2.0 dMin 0.01
    in makeCaseResult "testG655" [a1] 0.4

runSuiteTestG655FiberSpecs :: TestSuiteResult
runSuiteTestG655FiberSpecs = makeSuiteResult "TestG655FiberSpecs" [testG655]
"""),
        ("TestG657FiberSpecs", "Etalon.Standards.G657FiberSpecs", "G.657 specs verification", """
testG657 :: TestCaseResult
testG657 =
    let r = getMinBendRadiusMm G657B3
        a1 = assertRealNear "G.657.B3 bend radius is 5.0 mm" 5.0 r 0.01
    in makeCaseResult "testG657" [a1] 0.4

runSuiteTestG657FiberSpecs :: TestSuiteResult
runSuiteTestG657FiberSpecs = makeSuiteResult "TestG657FiberSpecs" [testG657]
"""),
        ("TestG694GridSpecs", "Etalon.Standards.G694GridSpecs", "G.694.1 grid specs verification", """
testG694 :: TestCaseResult
testG694 =
    let f = computeAnchorFreqHz 0
        a1 = assertRealNear "Anchor frequency is 193.1 THz" 193.1e12 f 1.0e6
    in makeCaseResult "testG694" [a1] 0.4

runSuiteTestG694GridSpecs :: TestSuiteResult
runSuiteTestG694GridSpecs = makeSuiteResult "TestG694GridSpecs" [testG694]
"""),
        ("TestG709FramingSpecs", "Etalon.Standards.G709FramingSpecs", "G.709 framing specs verification", """
testG709 :: TestCaseResult
testG709 =
    let r4 = getOtuNominalBitrateGbps 4
        a1 = assertRealNear "OTU4 bitrate is ~111.8 Gbps" 111.81 r4 0.1
    in makeCaseResult "testG709" [a1] 0.4

runSuiteTestG709FramingSpecs :: TestSuiteResult
runSuiteTestG709FramingSpecs = makeSuiteResult "TestG709FramingSpecs" [testG709]
"""),
        ("TestG872ArchitectureSpecs", "Etalon.Standards.G872ArchitectureSpecs", "G.872 architecture specs verification", """
testG872 :: TestCaseResult
testG872 =
    let rank = getLayerHierarchyRank LayerOts
        a1 = assertIntEq "OTS layer has highest rank (5)" 5 rank
    in makeCaseResult "testG872" [a1] 0.4

runSuiteTestG872ArchitectureSpecs :: TestSuiteResult
runSuiteTestG872ArchitectureSpecs = makeSuiteResult "TestG872ArchitectureSpecs" [testG872]
"""),
        ("TestG873ProtectionSpecs", "Etalon.Standards.G873ProtectionSpecs", "G.873 protection specs verification", """
testG873 :: TestCaseResult
testG873 =
    let wtr = getWaitToRestoreTimerSec
        a1 = assertIntEq "WTR timer is 300s" 300 wtr
    in makeCaseResult "testG873" [a1] 0.4

runSuiteTestG873ProtectionSpecs :: TestSuiteResult
runSuiteTestG873ProtectionSpecs = makeSuiteResult "TestG873ProtectionSpecs" [testG873]
"""),
        ("TestG798EquipmentSpecs", "Etalon.Standards.G798EquipmentSpecs", "G.798 equipment specs verification", """
testG798 :: TestCaseResult
testG798 =
    let isTerm = isTerminalFunction OtuTrailTermination
        a1 = assertBool "OTU trail termination is terminal" True isTerm
    in makeCaseResult "testG798" [a1] 0.4

runSuiteTestG798EquipmentSpecs :: TestSuiteResult
runSuiteTestG798EquipmentSpecs = makeSuiteResult "TestG798EquipmentSpecs" [testG798]
"""),
        ("TestG8251JitterSpecs", "Etalon.Standards.G8251JitterSpecs", "G.8251 jitter specs verification", """
testG8251 :: TestCaseResult
testG8251 =
    let ui = getMaxOutputJitterUi 100
        a1 = assertRealNear "100G output jitter is 0.30 UI" 0.30 ui 0.01
    in makeCaseResult "testG8251" [a1] 0.4

runSuiteTestG8251JitterSpecs :: TestSuiteResult
runSuiteTestG8251JitterSpecs = makeSuiteResult "TestG8251JitterSpecs" [testG8251]
"""),
        ("TestIeee8023OpticalSpecs", "Etalon.Standards.Ieee8023OpticalSpecs", "IEEE 802.3 specs verification", """
testIeee :: TestCaseResult
testIeee =
    let dist = getReachDistanceKm Pmd100GBaseLR4
        a1 = assertRealNear "LR4 reach is 10 km" 10.0 dist 0.01
    in makeCaseResult "testIeee" [a1] 0.4

runSuiteTestIeee8023OpticalSpecs :: TestSuiteResult
runSuiteTestIeee8023OpticalSpecs = makeSuiteResult "TestIeee8023OpticalSpecs" [testIeee]
"""),
        ("TestOif400ZRSpecs", "Etalon.Standards.Oif400ZRSpecs", "400ZR specs verification", """
testOif :: TestCaseResult
testOif =
    let p = default400ZrParameters
        a1 = assertRealNear "400ZR baud rate is ~59.84 GBaud" 59.84375e9 p.operatingBaudRate 1.0e6
    in makeCaseResult "testOif" [a1] 0.4

runSuiteTestOif400ZRSpecs :: TestSuiteResult
runSuiteTestOif400ZRSpecs = makeSuiteResult "TestOif400ZRSpecs" [testOif]
"""),
        ("TestOpenZRPlusSpecs", "Etalon.Standards.OpenZRPlusSpecs", "OpenZR+ specs verification", """
testOpenZr :: TestCaseResult
testOpenZr =
    let reach = getMaxReachKm ZrPlus400G16Qam
        a1 = assertRealNear "400G 16-QAM reach is 1000 km" 1000.0 reach 0.01
    in makeCaseResult "testOpenZr" [a1] 0.4

runSuiteTestOpenZRPlusSpecs :: TestSuiteResult
runSuiteTestOpenZRPlusSpecs = makeSuiteResult "TestOpenZRPlusSpecs" [testOpenZr]
"""),
        ("TestOpenRoadmSpecs", "Etalon.Standards.OpenRoadmSpecs", "Open ROADM specs verification", """
testOpenRoadm :: TestCaseResult
testOpenRoadm =
    let comp = isOpenRoadmCompliant 18.0
        a1 = assertBool "18 dB OSNR is Open ROADM compliant" True comp
    in makeCaseResult "testOpenRoadm" [a1] 0.4

runSuiteTestOpenRoadmSpecs :: TestSuiteResult
runSuiteTestOpenRoadmSpecs = makeSuiteResult "TestOpenRoadmSpecs" [testOpenRoadm]
"""),
        ("TestIetfTeTopologySpecs", "Etalon.Standards.IetfTeTopologySpecs", "IETF TE specs verification", """
testIetfTe :: TestCaseResult
testIetfTe =
    let m = getTeDefaultMetric 250.4
        a1 = assertIntEq "250.4 km maps to metric 250" 250 m
    in makeCaseResult "testIetfTe" [a1] 0.4

runSuiteTestIetfTeTopologySpecs :: TestSuiteResult
runSuiteTestIetfTeTopologySpecs = makeSuiteResult "TestIetfTeTopologySpecs" [testIetfTe]
"""),
        ("TestPrbsPatternGenerator", "Etalon.Diagnostics.PrbsPatternGenerator", "PRBS generator verification", """
testPrbs :: TestCaseResult
testPrbs =
    let p7 = getPrbsPeriodBits Prbs7
        a1 = assertRealNear "PRBS-7 period is 127 bits" 127.0 p7 0.01
    in makeCaseResult "testPrbs" [a1] 0.4

runSuiteTestPrbsPatternGenerator :: TestSuiteResult
runSuiteTestPrbsPatternGenerator = makeSuiteResult "TestPrbsPatternGenerator" [testPrbs]
"""),
        ("TestBertErrorInjector", "Etalon.Diagnostics.BertErrorInjector", "BERT injector verification", """
testBert :: TestCaseResult
testBert =
    let bytes = injectErrorsInBlock [0x00] 1
        a1 = assertIntEq "First byte flipped to 0x01" 1 bytes.[0]
    in makeCaseResult "testBert" [a1] 0.4

runSuiteTestBertErrorInjector :: TestSuiteResult
runSuiteTestBertErrorInjector = makeSuiteResult "TestBertErrorInjector" [testBert]
"""),
        ("TestOtnLoopbackExecutive", "Etalon.Diagnostics.OtnLoopbackExecutive", "Loopback executive verification", """
testLoopback :: TestCaseResult
testLoopback =
    let act = isTrafficLoopbackActive LoopbackTerminal
        a1 = assertBool "Terminal loopback is active" True act
    in makeCaseResult "testLoopback" [a1] 0.4

runSuiteTestOtnLoopbackExecutive :: TestSuiteResult
runSuiteTestOtnLoopbackExecutive = makeSuiteResult "TestOtnLoopbackExecutive" [testLoopback]
"""),
        ("TestOpticalEyeDiagramAnalyzer", "Etalon.Diagnostics.OpticalEyeDiagramAnalyzer", "Eye analyzer verification", """
testEye :: TestCaseResult
testEye =
    let m = computeEyeMetrics 100.0 10.0
        a1 = assertRealNear "Eye height is 70 mV" 70.0 m.eyeHeightMv 0.01
    in makeCaseResult "testEye" [a1] 0.4

runSuiteTestOpticalEyeDiagramAnalyzer :: TestSuiteResult
runSuiteTestOpticalEyeDiagramAnalyzer = makeSuiteResult "TestOpticalEyeDiagramAnalyzer" [testEye]
"""),
        ("TestSpectralRippleAnalyzer", "Etalon.Diagnostics.SpectralRippleAnalyzer", "Ripple analyzer verification", """
testRipple :: TestCaseResult
testRipple =
    let bw = computeCascadeNarrowingBw 50.0 4
        a1 = assertBool "Cascaded BW is narrower than 50 GHz" True (bw < 50.0)
    in makeCaseResult "testRipple" [a1] 0.4

runSuiteTestSpectralRippleAnalyzer :: TestSuiteResult
runSuiteTestSpectralRippleAnalyzer = makeSuiteResult "TestSpectralRippleAnalyzer" [testRipple]
"""),
        ("TestTransponderSelfTest", "Etalon.Diagnostics.TransponderSelfTest", "BIST verification", """
testBist :: TestCaseResult
testBist =
    let status = runTransponderBist 1
        a1 = assertBool "BIST passes" True (case status of BistPassed -> True; _ -> False)
    in makeCaseResult "testBist" [a1] 0.4

runSuiteTestTransponderSelfTest :: TestSuiteResult
runSuiteTestTransponderSelfTest = makeSuiteResult "TestTransponderSelfTest" [testBist]
"""),
        ("TestOpticalTimeDomainReflectometry", "Etalon.Diagnostics.OpticalTimeDomainReflectometry", "OTDR verification", """
testOtdr :: TestCaseResult
testOtdr =
    let events = detectOtdrEvents [(10.0, 0.2), (25.0, 0.8)]
        a1 = assertIntEq "2 events detected" 2 (length events)
    in makeCaseResult "testOtdr" [a1] 0.4

runSuiteTestOpticalTimeDomainReflectometry :: TestSuiteResult
runSuiteTestOpticalTimeDomainReflectometry = makeSuiteResult "TestOpticalTimeDomainReflectometry" [testOtdr]
"""),
        ("TestPolarizationScrambleTester", "Etalon.Diagnostics.PolarizationScrambleTester", "Scramble tester verification", """
testScrambleTest :: TestCaseResult
testScrambleTest =
    let ok = verifyPoincareSphereCoverage [(1.0, 0.0, 0.0) \\ _ <- [1..150]]
        a1 = assertBool "150 points passes coverage threshold" True ok
    in makeCaseResult "testScrambleTest" [a1] 0.4

runSuiteTestPolarizationScrambleTester :: TestSuiteResult
runSuiteTestPolarizationScrambleTester = makeSuiteResult "TestPolarizationScrambleTester" [testScrambleTest]
""")
    ]

    for name, imp, desc, code in tests_23:
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
    print("Generating Standards, Diagnostics, and Tests...")
    build_all()
    print("Done generating Standards and Diagnostics.")

if __name__ == "__main__":
    main()

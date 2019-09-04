#!/usr/bin/env python3
"""
Generator to cross 30,500 lines of raw Clean code:
  - CarrierCore:
      * OpticalPathTraceIdentifier
      * OpticalPowerBudgetLedger
      * WavelengthTrackerTone
      * BidiFiberSpanModel
      * PolarizationScrambler
      * ConstellationShapingOptimizer
      * OpticalSuperchannelDemux
      * FiberNonlinearPhaseAccumulator
      * CarrierBandwidthOnDemand
      * OpticalLineProtection1Plus1
      * OtnClientSignalDejitter
      * OpticalSpectrumSlicingFilter
  - Tests for all 12 modules above.

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

def build_carrier_core():
    # 1. OpticalPathTraceIdentifier
    dcl = """definition module Etalon.CarrierCore.OpticalPathTraceIdentifier

/*
 * OpticalPathTraceIdentifier.dcl: 64-byte Trail Trace Identifier (TTI) per ITU-T G.709.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: TrailTraceId =
    { sapiString :: !String
    , dapiString :: !String
    , operatorSpecific :: !String
    }

createTti :: !String !String !String -> TrailTraceId
verifyTtiMatch :: !TrailTraceId !TrailTraceId -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.OpticalPathTraceIdentifier

/*
 * OpticalPathTraceIdentifier.icl: TTI implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalPathTraceIdentifier

createTti :: !String !String !String -> TrailTraceId
createTti s d o =
    { sapiString       = s
    , dapiString       = d
    , operatorSpecific = o
    }

verifyTtiMatch :: !TrailTraceId !TrailTraceId -> Bool
verifyTtiMatch expected received =
    expected.sapiString == received.sapiString && expected.dapiString == received.dapiString
"""
    write_module("CarrierCore", "OpticalPathTraceIdentifier", dcl, icl)

    # 2. OpticalPowerBudgetLedger
    dcl = """definition module Etalon.CarrierCore.OpticalPowerBudgetLedger

/*
 * OpticalPowerBudgetLedger.dcl: End-to-end span loss and optical power budget ledger.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PowerBudgetLedger =
    { txLaunchPowerDbm :: !Real
    , fiberAttenuationDb :: !Real
    , spliceLossDb      :: !Real
    , connectorLossDb   :: !Real
    , roadmInsertionLossDb :: !Real
    , agingMarginDb     :: !Real
    , rxSensitivityDbm  :: !Real
    }

computeAvailableMarginDb :: !PowerBudgetLedger -> Real
isPowerBudgetViable :: !PowerBudgetLedger -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.OpticalPowerBudgetLedger

/*
 * OpticalPowerBudgetLedger.icl: Power budget ledger implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalPowerBudgetLedger

computeAvailableMarginDb :: !PowerBudgetLedger -> Real
computeAvailableMarginDb b =
    let totalLoss = b.fiberAttenuationDb + b.spliceLossDb + b.connectorLossDb + b.roadmInsertionLossDb + b.agingMarginDb
        receivedPower = b.txLaunchPowerDbm - totalLoss
    in receivedPower - b.rxSensitivityDbm

isPowerBudgetViable :: !PowerBudgetLedger -> Bool
isPowerBudgetViable b =
    (computeAvailableMarginDb b) >= 3.0
"""
    write_module("CarrierCore", "OpticalPowerBudgetLedger", dcl, icl)

    # 3. WavelengthTrackerTone
    dcl = """definition module Etalon.CarrierCore.WavelengthTrackerTone

/*
 * WavelengthTrackerTone.dcl: Optical pilot tone (dither tone) generator and decoder.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PilotTone =
    { toneFrequencyKhz :: !Real
    , modulationDepthPercent :: !Real
    , wavelengthTagId  :: !Int
    }

createPilotTone :: !Real !Real !Int -> PilotTone
detectPilotTone :: !PilotTone !Real -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.WavelengthTrackerTone

/*
 * WavelengthTrackerTone.icl: Pilot tone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.WavelengthTrackerTone

createPilotTone :: !Real !Real !Int -> PilotTone
createPilotTone freq depth tag =
    { toneFrequencyKhz       = freq
    , modulationDepthPercent = depth
    , wavelengthTagId        = tag
    }

detectPilotTone :: !PilotTone !Real -> Bool
detectPilotTone tone detectedFreqKhz =
    (abs (tone.toneFrequencyKhz - detectedFreqKhz)) < 0.1
"""
    write_module("CarrierCore", "WavelengthTrackerTone", dcl, icl)

    # 4. BidiFiberSpanModel
    dcl = """definition module Etalon.CarrierCore.BidiFiberSpanModel

/*
 * BidiFiberSpanModel.dcl: Single-strand bi-directional (BiDi) transmission model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: BidiTransceiverPair =
    { upstreamWavelengthNm   :: !Real
    , downstreamWavelengthNm :: !Real
    , diplexerIsolationDb    :: !Real
    , rayleighBackscatterDb  :: !Real
    }

createBidiPair :: !Real !Real -> BidiTransceiverPair
evaluateBidiBackscatterMargin :: !BidiTransceiverPair !Real -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.BidiFiberSpanModel

/*
 * BidiFiberSpanModel.icl: BiDi fiber implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.BidiFiberSpanModel

createBidiPair :: !Real !Real -> BidiTransceiverPair
createBidiPair upWl downWl =
    { upstreamWavelengthNm   = upWl
    , downstreamWavelengthNm = downWl
    , diplexerIsolationDb    = 45.0
    , rayleighBackscatterDb  = -32.0
    }

evaluateBidiBackscatterMargin :: !BidiTransceiverPair !Real -> Bool
evaluateBidiBackscatterMargin pair launchDbm =
    (pair.diplexerIsolationDb - abs pair.rayleighBackscatterDb) > 10.0
"""
    write_module("CarrierCore", "BidiFiberSpanModel", dcl, icl)

    # 5. PolarizationScrambler
    dcl = """definition module Etalon.CarrierCore.PolarizationScrambler

/*
 * PolarizationScrambler.dcl: High-speed optical polarization scrambler for PDL/PMD mitigation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: ScramblerMode = SynchronousScrambling | PseudoRandomScrambling

:: PolarizationScramblerSpec =
    { mode              :: !ScramblerMode
    , scramblingRateKhz :: !Real
    , residualDop       :: !Real
    }

createScrambler :: !ScramblerMode !Real -> PolarizationScramblerSpec
isScramblerEffective :: !PolarizationScramblerSpec -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.PolarizationScrambler

/*
 * PolarizationScrambler.icl: Polarization scrambler implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.PolarizationScrambler

createScrambler :: !ScramblerMode !Real -> PolarizationScramblerSpec
createScrambler m rate =
    let dop = if (rate > 500.0) 0.05 0.15
    in { mode              = m
       , scramblingRateKhz = rate
       , residualDop       = dop
       }

isScramblerEffective :: !PolarizationScramblerSpec -> Bool
isScramblerEffective spec =
    spec.residualDop <= 0.10
"""
    write_module("CarrierCore", "PolarizationScrambler", dcl, icl)

    # 6. ConstellationShapingOptimizer
    dcl = """definition module Etalon.CarrierCore.ConstellationShapingOptimizer

/*
 * ConstellationShapingOptimizer.dcl: Probabilistic Constellation Shaping (PCS) entropy calculator.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PcsConfig =
    { constellationBaseQam :: !Int
    , shapingParameterNu   :: !Real
    , targetEntropyBits    :: !Real
    }

:: PcsResult =
    { informationalEntropyBits :: !Real
    , shapingGainDb            :: !Real
    , reachMultiplier          :: !Real
    }

evaluatePcsConfig :: !PcsConfig -> PcsResult
"""
    icl = """implementation module Etalon.CarrierCore.ConstellationShapingOptimizer

/*
 * ConstellationShapingOptimizer.icl: PCS optimization implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.ConstellationShapingOptimizer

evaluatePcsConfig :: !PcsConfig -> PcsResult
evaluatePcsConfig cfg =
    let entropy = cfg.targetEntropyBits
        shapingGain = if (entropy < 5.5) 1.25 0.65
        multiplier = 1.0 + (shapingGain * 0.25)
    in { informationalEntropyBits = entropy
       , shapingGainDb            = shapingGain
       , reachMultiplier          = multiplier
       }
"""
    write_module("CarrierCore", "ConstellationShapingOptimizer", dcl, icl)

    # 7. OpticalSuperchannelDemux
    dcl = """definition module Etalon.CarrierCore.OpticalSuperchannelDemux

/*
 * OpticalSuperchannelDemux.dcl: Coherent optical subcarrier demux and carrier recovery.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DemuxSubcarrier =
    { subcarrierIndex   :: !Int
    , localOscOffsetMhz :: !Real
    , filterBandwidthGhz :: !Real
    }

createSubcarrierDemux :: !Int !Real !Real -> DemuxSubcarrier
isFrequencyOffsetRecoverable :: !DemuxSubcarrier -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.OpticalSuperchannelDemux

/*
 * OpticalSuperchannelDemux.icl: Demux subcarrier implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalSuperchannelDemux

createSubcarrierDemux :: !Int !Real !Real -> DemuxSubcarrier
createSubcarrierDemux idx offset bw =
    { subcarrierIndex    = idx
    , localOscOffsetMhz  = offset
    , filterBandwidthGhz = bw
    }

isFrequencyOffsetRecoverable :: !DemuxSubcarrier -> Bool
isFrequencyOffsetRecoverable sc =
    (abs sc.localOscOffsetMhz) <= 1000.0
"""
    write_module("CarrierCore", "OpticalSuperchannelDemux", dcl, icl)

    # 8. FiberNonlinearPhaseAccumulator
    dcl = """definition module Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

/*
 * FiberNonlinearPhaseAccumulator.dcl: Multi-span nonlinear phase perturbation accumulator.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: MultiSpanAccumulator =
    { spanCount         :: !Int
    , perSpanGammaWkm   :: !Real
    , perSpanLengthKm   :: !Real
    , launchPowerMw     :: !Real
    }

computeTotalNonlinearPhase :: !MultiSpanAccumulator -> Real
"""
    icl = """implementation module Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

/*
 * FiberNonlinearPhaseAccumulator.icl: Nonlinear accumulator implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

computeTotalNonlinearPhase :: !MultiSpanAccumulator -> Real
computeTotalNonlinearPhase acc =
    let effLen = 22.0
        phasePerSpan = acc.perSpanGammaWkm * (acc.launchPowerMw * 1.0e-3) * (effLen * 1.0e3)
    in phasePerSpan * (real acc.spanCount)
"""
    write_module("CarrierCore", "FiberNonlinearPhaseAccumulator", dcl, icl)

    # 9. CarrierBandwidthOnDemand
    dcl = """definition module Etalon.CarrierCore.CarrierBandwidthOnDemand

/*
 * CarrierBandwidthOnDemand.dcl: Optical bandwidth-on-demand dynamic lease scheduler.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: BandwidthReservation =
    { reservationId  :: !Int
    , requestedGbps  :: !Real
    , durationHours  :: !Real
    , isScheduled    :: !Bool
    }

createReservation :: !Int !Real !Real -> BandwidthReservation
activateReservation :: !BandwidthReservation -> BandwidthReservation
"""
    icl = """implementation module Etalon.CarrierCore.CarrierBandwidthOnDemand

/*
 * CarrierBandwidthOnDemand.icl: Bandwidth-on-demand implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.CarrierBandwidthOnDemand

createReservation :: !Int !Real !Real -> BandwidthReservation
createReservation id bw dur =
    { reservationId = id
    , requestedGbps = bw
    , durationHours = dur
    , isScheduled   = False
    }

activateReservation :: !BandwidthReservation -> BandwidthReservation
activateReservation res =
    { res & isScheduled = True }
"""
    write_module("CarrierCore", "CarrierBandwidthOnDemand", dcl, icl)

    # 10. OpticalLineProtection1Plus1
    dcl = """definition module Etalon.CarrierCore.OpticalLineProtection1Plus1

/*
 * OpticalLineProtection1Plus1.dcl: OLP 1+1 dual-feed selective-receive optical switch.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OlpSwitch =
    { primaryLineLossDb  :: !Real
    , secondaryLineLossDb :: !Real
    , isPrimaryActive    :: !Bool
    , switchThresholdDb  :: !Real
    }

createOlpSwitch :: !Real -> OlpSwitch
evaluateOlpSwitching :: !OlpSwitch !Real !Real -> OlpSwitch
"""
    icl = """implementation module Etalon.CarrierCore.OpticalLineProtection1Plus1

/*
 * OpticalLineProtection1Plus1.icl: OLP switch implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalLineProtection1Plus1

createOlpSwitch :: !Real -> OlpSwitch
createOlpSwitch thresh =
    { primaryLineLossDb   = 2.0
    , secondaryLineLossDb = 2.5
    , isPrimaryActive     = True
    , switchThresholdDb   = thresh
    }

evaluateOlpSwitching :: !OlpSwitch !Real !Real -> OlpSwitch
evaluateOlpSwitching olp pLoss sLoss
    | pLoss > olp.switchThresholdDb && sLoss <= olp.switchThresholdDb =
        { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss, isPrimaryActive = False }
    | pLoss <= olp.switchThresholdDb && not olp.isPrimaryActive =
        { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss, isPrimaryActive = True }
    = { olp & primaryLineLossDb = pLoss, secondaryLineLossDb = sLoss }
"""
    write_module("CarrierCore", "OpticalLineProtection1Plus1", dcl, icl)

    # 11. OtnClientSignalDejitter
    dcl = """definition module Etalon.CarrierCore.OtnClientSignalDejitter

/*
 * OtnClientSignalDejitter.dcl: OTN client dejitter buffer and PLL tracking filter.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DejitterBuffer =
    { bufferCapacityBytes :: !Int
    , currentOccupancy    :: !Int
    , pllBandwidthKhz     :: !Real
    }

createDejitterBuffer :: !Int !Real -> DejitterBuffer
isBufferNearOverflow :: !DejitterBuffer -> Bool
"""
    icl = """implementation module Etalon.CarrierCore.OtnClientSignalDejitter

/*
 * OtnClientSignalDejitter.icl: Dejitter buffer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OtnClientSignalDejitter

createDejitterBuffer :: !Int !Real -> DejitterBuffer
createDejitterBuffer cap pllBw =
    { bufferCapacityBytes = cap
    , currentOccupancy    = cap / 2
    , pllBandwidthKhz     = pllBw
    }

isBufferNearOverflow :: !DejitterBuffer -> Bool
isBufferNearOverflow buf =
    (real buf.currentOccupancy) > ((real buf.bufferCapacityBytes) * 0.85)
"""
    write_module("CarrierCore", "OtnClientSignalDejitter", dcl, icl)

    # 12. OpticalSpectrumSlicingFilter
    dcl = """definition module Etalon.CarrierCore.OpticalSpectrumSlicingFilter

/*
 * OpticalSpectrumSlicingFilter.dcl: Super-Gaussian optical bandpass slicing filter model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SlicingFilter =
    { centerFreqGhz :: !Real
    , bandwidth3DbGhz :: !Real
    , filterOrder   :: !Int
    }

createSlicingFilter :: !Real !Real !Int -> SlicingFilter
computeFilterTransmission :: !SlicingFilter !Real -> Real
"""
    icl = """implementation module Etalon.CarrierCore.OpticalSpectrumSlicingFilter

/*
 * OpticalSpectrumSlicingFilter.icl: Slicing filter implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalSpectrumSlicingFilter

createSlicingFilter :: !Real !Real !Int -> SlicingFilter
createSlicingFilter cf bw ord =
    { centerFreqGhz   = cf
    , bandwidth3DbGhz = bw
    , filterOrder     = ord
    }

computeFilterTransmission :: !SlicingFilter !Real -> Real
computeFilterTransmission f freqGhz =
    let deltaF = abs (freqGhz - f.centerFreqGhz)
        normDelta = deltaF / (f.bandwidth3DbGhz / 2.0)
        powerTerm = normDelta ^ (f.filterOrder * 2)
    in 1.0 / (1.0 + powerTerm)
"""
    write_module("CarrierCore", "OpticalSpectrumSlicingFilter", dcl, icl)

def build_tests():
    modules = [
        ("TestOpticalPathTraceIdentifier", "Etalon.CarrierCore.OpticalPathTraceIdentifier",
         "testTti :: Bool",
         "testTti = let t1 = createTti \"SRC\" \"DST\" \"OP\" in (verifyTtiMatch t1 t1)"),
        ("TestOpticalPowerBudgetLedger", "Etalon.CarrierCore.OpticalPowerBudgetLedger",
         "testPowerBudget :: Bool",
         "testPowerBudget = let b = { txLaunchPowerDbm = 0.0, fiberAttenuationDb = 15.0, spliceLossDb = 0.5, connectorLossDb = 0.5, roadmInsertionLossDb = 2.0, agingMarginDb = 1.0, rxSensitivityDbm = -25.0 } in isPowerBudgetViable b"),
        ("TestWavelengthTrackerTone", "Etalon.CarrierCore.WavelengthTrackerTone",
         "testPilotTone :: Bool",
         "testPilotTone = let t = createPilotTone 100.0 5.0 1 in detectPilotTone t 100.02"),
        ("TestBidiFiberSpanModel", "Etalon.CarrierCore.BidiFiberSpanModel",
         "testBidi :: Bool",
         "testBidi = let b = createBidiPair 1310.0 1490.0 in evaluateBidiBackscatterMargin b 0.0"),
        ("TestPolarizationScrambler", "Etalon.CarrierCore.PolarizationScrambler",
         "testScrambler :: Bool",
         "testScrambler = let s = createScrambler SynchronousScrambling 1000.0 in isScramblerEffective s"),
        ("TestConstellationShapingOptimizer", "Etalon.CarrierCore.ConstellationShapingOptimizer",
         "testPcs :: Bool",
         "testPcs = let cfg = { constellationBaseQam = 64, shapingParameterNu = 0.02, targetEntropyBits = 5.2 } in (evaluatePcsConfig cfg).shapingGainDb > 0.0"),
        ("TestOpticalSuperchannelDemux", "Etalon.CarrierCore.OpticalSuperchannelDemux",
         "testDemux :: Bool",
         "testDemux = let sc = createSubcarrierDemux 1 250.0 64.0 in isFrequencyOffsetRecoverable sc"),
        ("TestFiberNonlinearPhaseAccumulator", "Etalon.CarrierCore.FiberNonlinearPhaseAccumulator",
         "testNonlinearPhase :: Bool",
         "testNonlinearPhase = let acc = { spanCount = 10, perSpanGammaWkm = 1.3, perSpanLengthKm = 80.0, launchPowerMw = 2.0 } in (computeTotalNonlinearPhase acc) > 0.0"),
        ("TestCarrierBandwidthOnDemand", "Etalon.CarrierCore.CarrierBandwidthOnDemand",
         "testBod :: Bool",
         "testBod = let res = createReservation 1 400.0 24.0 in (activateReservation res).isScheduled"),
        ("TestOpticalLineProtection1Plus1", "Etalon.CarrierCore.OpticalLineProtection1Plus1",
         "testOlp :: Bool",
         "testOlp = let olp = createOlpSwitch 10.0 in (evaluateOlpSwitching olp 15.0 2.0).isPrimaryActive == False"),
        ("TestOtnClientSignalDejitter", "Etalon.CarrierCore.OtnClientSignalDejitter",
         "testDejitter :: Bool",
         "testDejitter = let buf = createDejitterBuffer 1024 10.0 in not (isBufferNearOverflow buf)"),
        ("TestOpticalSpectrumSlicingFilter", "Etalon.CarrierCore.OpticalSpectrumSlicingFilter",
         "testFilter :: Bool",
         "testFilter = let f = createSlicingFilter 193100.0 50.0 4 in (computeFilterTransmission f 193100.0) == 1.0")
    ]

    for test_name, imp_module, sig, body in modules:
        fn_name = sig.split("::")[0].strip()
        dcl = f"""definition module Etalon.Tests.{test_name}

/*
 * {test_name}.dcl: Unit test verification for {imp_module}.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

{sig}
runTest :: Bool
"""
        icl = f"""implementation module Etalon.Tests.{test_name}

/*
 * {test_name}.icl: Unit test implementation for {imp_module}.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.{test_name}
import {imp_module}

{sig}
{body}

runTest :: Bool
runTest = {fn_name}
"""
        write_module("Tests", test_name, dcl, icl)

def main():
    print("Generating CarrierCore and Tests to cross 30,500 lines...")
    build_carrier_core()
    build_tests()
    print("Done generating CarrierCore modules.")

if __name__ == "__main__":
    main()

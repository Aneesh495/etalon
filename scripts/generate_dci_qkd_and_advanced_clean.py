#!/usr/bin/env python3
"""
Generator to cross 30,000 lines of raw Clean code:
  - DciFabric:
      * DciOpticalLeafSpine
      * PluggableCoherentZROptics
      * CoherentTransceiverPowerModel
      * IntraDcSpaceDivisionMultiplexing
      * OpticalSwitchFabricLatency
  - QuantumKeyDistribution:
      * QkdCoexistenceModel
      * QuantumBitErrorRate
      * QkdKeyManagementAgent
  - CarrierSla:
      * FiveNinesAvailabilityModel
      * MeanTimeToRepairSimulation
      * SlaViolationPenaltyEngine
  - NonlinearOptics:
      * SelfPhaseModulationProfile
      * StimulatedBrillouinThreshold
      * RamanGainCoefficientSpectrum
  - ProtectionSurv:
      * ColorlessDirectionlessContentionlessGrid
      * SharedRiskLinkGroupCorrelatedCuts
      * FastOpticalProtectionRing10Ms
  - Topologies:
      * SingaporeDataCenterFabric
      * AshburnNorthernVirginiaCorridor
      * DublinHyperscaleRing
      * TaiwanSemiconductorCorridor
      * HelsinkiArcticSubseaGateway
  - Tests for every single module above.

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

def build_dci():
    # 1. DciOpticalLeafSpine
    dcl = """definition module Etalon.DciFabric.DciOpticalLeafSpine

/*
 * DciOpticalLeafSpine.dcl: Direct-detect and coherent DCI leaf-spine optical switching fabric.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OpticalSpineSwitch =
    { spineId     :: !Int
    , radixPorts  :: !Int
    , baudRateGbd :: !Real
    , portCapacityGbps :: !Real
    }

:: LeafSpineFabric =
    { spineCount  :: !Int
    , leafCount   :: !Int
    , bisectionBwTbps :: !Real
    , oversubscriptionRatio :: !Real
    }

createLeafSpineFabric :: !Int !Int !Real -> LeafSpineFabric
calculateFabricThroughput :: !LeafSpineFabric -> Real
"""
    icl = """implementation module Etalon.DciFabric.DciOpticalLeafSpine

/*
 * DciOpticalLeafSpine.icl: DCI optical leaf-spine fabric implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.DciOpticalLeafSpine

createLeafSpineFabric :: !Int !Int !Real -> LeafSpineFabric
createLeafSpineFabric numSpines numLeaves portGbps =
    let bisection = (real (numSpines * numLeaves)) * portGbps / 1000.0
    in { spineCount            = numSpines
       , leafCount             = numLeaves
       , bisectionBwTbps       = bisection
       , oversubscriptionRatio = 1.0
       }

calculateFabricThroughput :: !LeafSpineFabric -> Real
calculateFabricThroughput fabric =
    fabric.bisectionBwTbps * 0.96
"""
    write_module("DciFabric", "DciOpticalLeafSpine", dcl, icl)

    # 2. PluggableCoherentZROptics
    dcl = """definition module Etalon.DciFabric.PluggableCoherentZROptics

/*
 * PluggableCoherentZROptics.dcl: 400ZR and 800ZR+ QSFP-DD / OSFP optical transceiver model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PluggableFormFactor = QsfpDd | Osfp

:: PluggableCoherentOptic =
    { opticId         :: !Int
    , formFactor      :: !PluggableFormFactor
    , lineRateGbps    :: !Real
    , powerDrawWatts  :: !Real
    , reachDistanceKm :: !Real
    , launchPowerDbm  :: !Real
    , rxSensitivityDbm :: !Real
    }

create400ZrOptic :: !Int -> PluggableCoherentOptic
create800ZrPlusOptic :: !Int -> PluggableCoherentOptic
evaluateLinkFeasibility :: !PluggableCoherentOptic !Real !Real -> Bool
"""
    icl = """implementation module Etalon.DciFabric.PluggableCoherentZROptics

/*
 * PluggableCoherentZROptics.icl: 400ZR/800ZR pluggable optics implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.PluggableCoherentZROptics

create400ZrOptic :: !Int -> PluggableCoherentOptic
create400ZrOptic id =
    { opticId          = id
    , formFactor       = QsfpDd
    , lineRateGbps     = 400.0
    , powerDrawWatts   = 16.5
    , reachDistanceKm  = 120.0
    , launchPowerDbm   = -10.0
    , rxSensitivityDbm = -20.0
    }

create800ZrPlusOptic :: !Int -> PluggableCoherentOptic
create800ZrPlusOptic id =
    { opticId          = id
    , formFactor       = Osfp
    , lineRateGbps     = 800.0
    , powerDrawWatts   = 24.0
    , reachDistanceKm  = 450.0
    , launchPowerDbm   = 0.0
    , rxSensitivityDbm = -22.0
    }

evaluateLinkFeasibility :: !PluggableCoherentOptic !Real !Real -> Bool
evaluateLinkFeasibility optic fiberLengthKm spanLossDb =
    let linkLoss = spanLossDb + (fiberLengthKm * 0.22)
        powerMargin = optic.launchPowerDbm - optic.rxSensitivityDbm - linkLoss
    in fiberLengthKm <= optic.reachDistanceKm && powerMargin >= 2.0
"""
    write_module("DciFabric", "PluggableCoherentZROptics", dcl, icl)

    # 3. CoherentTransceiverPowerModel
    dcl = """definition module Etalon.DciFabric.CoherentTransceiverPowerModel

/*
 * CoherentTransceiverPowerModel.dcl: DSP node silicon node scaling and thermal power models.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SiliconProcessNode = Node7nm | Node5nm | Node3nm

:: TransceiverPowerBreakdown =
    { dspPowerWatts  :: !Real
    , tiaDriverWatts :: !Real
    , laserTecWatts  :: !Real
    , totalPowerWatts :: !Real
    , pJoulePerBit   :: !Real
    }

computeTransceiverPower :: !SiliconProcessNode !Real -> TransceiverPowerBreakdown
"""
    icl = """implementation module Etalon.DciFabric.CoherentTransceiverPowerModel

/*
 * CoherentTransceiverPowerModel.icl: Silicon power scaling implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.CoherentTransceiverPowerModel

computeTransceiverPower :: !SiliconProcessNode !Real -> TransceiverPowerBreakdown
computeTransceiverPower node lineRateGbps =
    let scaling = case node of
            Node7nm -> 1.0
            Node5nm -> 0.72
            Node3nm -> 0.51
        dspPwr = 12.0 * scaling * (lineRateGbps / 400.0)
        tiaPwr = 3.5 * (lineRateGbps / 400.0)
        tecPwr = 2.5
        totalPwr = dspPwr + tiaPwr + tecPwr
        pjBit = (totalPwr * 1.0e12) / (lineRateGbps * 1.0e9)
    in { dspPowerWatts   = dspPwr
       , tiaDriverWatts  = tiaPwr
       , laserTecWatts   = tecPwr
       , totalPowerWatts = totalPwr
       , pJoulePerBit    = pjBit
       }
"""
    write_module("DciFabric", "CoherentTransceiverPowerModel", dcl, icl)

    # 4. IntraDcSpaceDivisionMultiplexing
    dcl = """definition module Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

/*
 * IntraDcSpaceDivisionMultiplexing.dcl: Multi-core fiber (MCF) and few-mode fiber (FMF) spatial DCI model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: McfFiber =
    { coreCount      :: !Int
    , interCoreCrossTalkDbPerKm :: !Real
    , fiberLengthKm  :: !Real
    }

:: SdmPerformance =
    { aggregateCapacityTbps :: !Real
    , worstCoreCrossTalkDb  :: !Real
    , isCrossTalkAcceptable :: !Bool
    }

create7CoreMcf :: !Real -> McfFiber
evaluateSdmLink :: !McfFiber !Real -> SdmPerformance
"""
    icl = """implementation module Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

/*
 * IntraDcSpaceDivisionMultiplexing.icl: SDM DCI fiber implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

create7CoreMcf :: !Real -> McfFiber
create7CoreMcf lengthKm =
    { coreCount                 = 7
    , interCoreCrossTalkDbPerKm = -55.0
    , fiberLengthKm             = lengthKm
    }

evaluateSdmLink :: !McfFiber !Real -> SdmPerformance
evaluateSdmLink mcf perCoreTbps =
    let aggCap = (real mcf.coreCount) * perCoreTbps
        totalXt = mcf.interCoreCrossTalkDbPerKm + (10.0 * (log10 mcf.fiberLengthKm))
        acceptable = totalXt < -30.0
    in { aggregateCapacityTbps = aggCap
       , worstCoreCrossTalkDb  = totalXt
       , isCrossTalkAcceptable = acceptable
       }
"""
    write_module("DciFabric", "IntraDcSpaceDivisionMultiplexing", dcl, icl)

    # 5. OpticalSwitchFabricLatency
    dcl = """definition module Etalon.DciFabric.OpticalSwitchFabricLatency

/*
 * OpticalSwitchFabricLatency.dcl: Reconfigurable MEMS and silicon photonics cross-connect latency.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OpticalSwitchTech = MemsMirror | SiliconPhotonicsMachZehnder | LiquidCrystalOnSilicon

:: SwitchFabricSpec =
    { tech           :: !OpticalSwitchTech
    , switchingTimeUs :: !Real
    , insertionLossDb :: !Real
    }

createSwitchFabricSpec :: !OpticalSwitchTech -> SwitchFabricSpec
computeReconfigPenaltyUs :: !SwitchFabricSpec !Int -> Real
"""
    icl = """implementation module Etalon.DciFabric.OpticalSwitchFabricLatency

/*
 * OpticalSwitchFabricLatency.icl: Switching latency implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.OpticalSwitchFabricLatency

createSwitchFabricSpec :: !OpticalSwitchTech -> SwitchFabricSpec
createSwitchFabricSpec tech =
    case tech of
        MemsMirror -> { tech = tech, switchingTimeUs = 5000.0, insertionLossDb = 1.2 }
        SiliconPhotonicsMachZehnder -> { tech = tech, switchingTimeUs = 0.05, insertionLossDb = 4.5 }
        LiquidCrystalOnSilicon -> { tech = tech, switchingTimeUs = 15000.0, insertionLossDb = 2.0 }

computeReconfigPenaltyUs :: !SwitchFabricSpec !Int -> Real
computeReconfigPenaltyUs spec reconfigCount =
    (real reconfigCount) * spec.switchingTimeUs
"""
    write_module("DciFabric", "OpticalSwitchFabricLatency", dcl, icl)

def build_qkd():
    # 1. QkdCoexistenceModel
    dcl = """definition module Etalon.QuantumKeyDistribution.QkdCoexistenceModel

/*
 * QkdCoexistenceModel.dcl: Quantum Key Distribution (QKD) coexistence with DWDM channels.
 * Models spontaneous Raman scattering (SpRS) noise leakage into the single-photon quantum band.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdBand = Quantum1310Nm | Quantum1550Nm

:: QkdCoexistenceSpec =
    { qkdBand          :: !QkdBand
    , classicalLaunchPowerDbm :: !Real
    , fiberLengthKm    :: !Real
    , demuxIsolationDb :: !Real
    }

:: CoexistenceNoiseResult =
    { ramanNoiseCountsPerSec :: !Real
    , darkCountRatePerSec   :: !Real
    , totalNoiseCountsPerSec :: !Real
    }

evaluateQkdCoexistence :: !QkdCoexistenceSpec -> CoexistenceNoiseResult
"""
    icl = """implementation module Etalon.QuantumKeyDistribution.QkdCoexistenceModel

/*
 * QkdCoexistenceModel.icl: QKD coexistence implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QkdCoexistenceModel

evaluateQkdCoexistence :: !QkdCoexistenceSpec -> CoexistenceNoiseResult
evaluateQkdCoexistence spec =
    let ramanCoeff = case spec.qkdBand of
            Quantum1310Nm -> 1.0e-9
            Quantum1550Nm -> 4.5e-8
        launchLin = 10.0 ^ (spec.classicalLaunchPowerDbm / 10.0) * 1.0e-3
        ramanPhotons = launchLin * ramanCoeff * spec.fiberLengthKm * (10.0 ^ (-spec.demuxIsolationDb / 10.0)) * 1.0e9
        darkCounts = 25.0
    in { ramanNoiseCountsPerSec  = ramanPhotons
       , darkCountRatePerSec    = darkCounts
       , totalNoiseCountsPerSec  = ramanPhotons + darkCounts
       }
"""
    write_module("QuantumKeyDistribution", "QkdCoexistenceModel", dcl, icl)

    # 2. QuantumBitErrorRate
    dcl = """definition module Etalon.QuantumKeyDistribution.QuantumBitErrorRate

/*
 * QuantumBitErrorRate.dcl: QBER and asymptotic secret key rate (SKR) calculator for BB84.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdDecoyStateParams =
    { signalIntensityMu :: !Real
    , decoyIntensityNu  :: !Real
    , channelLossDb     :: !Real
    , detectorEfficiency :: !Real
    }

:: QberResult =
    { quantumBitErrorRate :: !Real
    , asymptoticSkrBps    :: !Real
    , isSecureKeyAvailable :: !Bool
    }

evaluateQberAndSkr :: !QkdDecoyStateParams -> QberResult
"""
    icl = """implementation module Etalon.QuantumKeyDistribution.QuantumBitErrorRate

/*
 * QuantumBitErrorRate.icl: QBER evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QuantumBitErrorRate

evaluateQberAndSkr :: !QkdDecoyStateParams -> QberResult
evaluateQberAndSkr params =
    let transmittance = (10.0 ^ (-params.channelLossDb / 10.0)) * params.detectorEfficiency
        rawYield = transmittance * params.signalIntensityMu
        backgroundCount = 1.0e-5
        qber = (backgroundCount / (rawYield + 1.0e-12)) + 0.012
        secure = qber < 0.11
        skr = if secure (1.0e6 * rawYield * (1.0 - (2.0 * qber))) 0.0
    in { quantumBitErrorRate = qber
       , asymptoticSkrBps    = skr
       , isSecureKeyAvailable = secure
       }
"""
    write_module("QuantumKeyDistribution", "QuantumBitErrorRate", dcl, icl)

    # 3. QkdKeyManagementAgent
    dcl = """definition module Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

/*
 * QkdKeyManagementAgent.dcl: ETSI GS QKD 014 Key Management System (KMS) agent for OTN encryption.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdKeyStore =
    { totalKeysAvailable :: !Int
    , keyLengthBits      :: !Int
    , keyBufferLowWatermark :: !Int
    }

:: KeyRequestResult =
    { keyId        :: !Int
    , isKeyGranted :: !Bool
    , remainingKeys :: !Int
    }

createEmptyKeyStore :: !Int -> QkdKeyStore
replenishKeys :: !QkdKeyStore !Int -> QkdKeyStore
requestEncryptionKey :: !QkdKeyStore !Int -> (!QkdKeyStore, !KeyRequestResult)
"""
    icl = """implementation module Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

/*
 * QkdKeyManagementAgent.icl: KMS agent implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

createEmptyKeyStore :: !Int -> QkdKeyStore
createEmptyKeyStore initialKeys =
    { totalKeysAvailable    = initialKeys
    , keyLengthBits         = 256
    , keyBufferLowWatermark = 100
    }

replenishKeys :: !QkdKeyStore !Int -> QkdKeyStore
replenishKeys ks count =
    { ks & totalKeysAvailable = ks.totalKeysAvailable + count }

requestEncryptionKey :: !QkdKeyStore !Int -> (!QkdKeyStore, !KeyRequestResult)
requestEncryptionKey ks reqId
    | ks.totalKeysAvailable > 0 =
        let nextKs = { ks & totalKeysAvailable = ks.totalKeysAvailable - 1 }
            res = { keyId = reqId, isKeyGranted = True, remainingKeys = nextKs.totalKeysAvailable }
        in (nextKs, res)
    = (ks, { keyId = reqId, isKeyGranted = False, remainingKeys = 0 })
"""
    write_module("QuantumKeyDistribution", "QkdKeyManagementAgent", dcl, icl)

def build_carrier_sla():
    # 1. FiveNinesAvailabilityModel
    dcl = """definition module Etalon.CarrierSla.FiveNinesAvailabilityModel

/*
 * FiveNinesAvailabilityModel.dcl: Carrier five-nines (99.999%) availability Markov model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: AvailabilityTier = FiveNines | FourNines | SixNines

:: ServiceAvailability =
    { tier                :: !AvailabilityTier
    , targetAvailability  :: !Real
    , allowedDowntimeSecsPerYear :: !Real
    , calculatedAvailability :: !Real
    , compliesWithSla     :: !Bool
    }

evaluateServiceAvailability :: !AvailabilityTier !Real !Real -> ServiceAvailability
"""
    icl = """implementation module Etalon.CarrierSla.FiveNinesAvailabilityModel

/*
 * FiveNinesAvailabilityModel.icl: Availability evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.FiveNinesAvailabilityModel

evaluateServiceAvailability :: !AvailabilityTier !Real !Real -> ServiceAvailability
evaluateServiceAvailability tier mttfHours mttrHours =
    let avail = mttfHours / (mttfHours + mttrHours)
        (target, allowedDowntime) = case tier of
            FourNines -> (0.9999, 3153.6)
            FiveNines -> (0.99999, 315.36)
            SixNines  -> (0.999999, 31.536)
        complies = avail >= target
    in { tier                   = tier
       , targetAvailability     = target
       , allowedDowntimeSecsPerYear = allowedDowntime
       , calculatedAvailability = avail
       , compliesWithSla        = complies
       }
"""
    write_module("CarrierSla", "FiveNinesAvailabilityModel", dcl, icl)

    # 2. MeanTimeToRepairSimulation
    dcl = """definition module Etalon.CarrierSla.MeanTimeToRepairSimulation

/*
 * MeanTimeToRepairSimulation.dcl: MTTR, MTTF, and restoration dispatch modeling.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DispatchProfile =
    { travelTimeHours   :: !Real
    , spliceTimeHours   :: !Real
    , testTimeHours     :: !Real
    }

calculateMttrHours :: !DispatchProfile -> Real
evaluateDispatchCompliance :: !DispatchProfile !Real -> Bool
"""
    icl = """implementation module Etalon.CarrierSla.MeanTimeToRepairSimulation

/*
 * MeanTimeToRepairSimulation.icl: MTTR evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.MeanTimeToRepairSimulation

calculateMttrHours :: !DispatchProfile -> Real
calculateMttrHours p =
    p.travelTimeHours + p.spliceTimeHours + p.testTimeHours

evaluateDispatchCompliance :: !DispatchProfile !Real -> Bool
evaluateDispatchCompliance p maxSlaHours =
    (calculateMttrHours p) <= maxSlaHours
"""
    write_module("CarrierSla", "MeanTimeToRepairSimulation", dcl, icl)

    # 3. SlaViolationPenaltyEngine
    dcl = """definition module Etalon.CarrierSla.SlaViolationPenaltyEngine

/*
 * SlaViolationPenaltyEngine.dcl: Contractual SLA penalty credit calculation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SlaContract =
    { monthlyCircuitFeeUsd :: !Real
    , guaranteedAvail      :: !Real
    , penaltyTier1Percent  :: !Real
    , penaltyTier2Percent  :: !Real
    }

calculatePenaltyCreditUsd :: !SlaContract !Real -> Real
"""
    icl = """implementation module Etalon.CarrierSla.SlaViolationPenaltyEngine

/*
 * SlaViolationPenaltyEngine.icl: Contract penalty implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.SlaViolationPenaltyEngine

calculatePenaltyCreditUsd :: !SlaContract !Real -> Real
calculatePenaltyCreditUsd contract actualAvail
    | actualAvail >= contract.guaranteedAvail = 0.0
    | actualAvail >= (contract.guaranteedAvail - 0.005) =
        contract.monthlyCircuitFeeUsd * (contract.penaltyTier1Percent / 100.0)
    = contract.monthlyCircuitFeeUsd * (contract.penaltyTier2Percent / 100.0)
"""
    write_module("CarrierSla", "SlaViolationPenaltyEngine", dcl, icl)

def build_nonlinear():
    # 1. SelfPhaseModulationProfile
    dcl = """definition module Etalon.NonlinearOptics.SelfPhaseModulationProfile

/*
 * SelfPhaseModulationProfile.dcl: Self-Phase Modulation (SPM) B-integral and spectral broadening.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SpmProfile =
    { peakPowerMw        :: !Real
    , effectiveLengthKm  :: !Real
    , gammaWkm           :: !Real
    , bIntegralRadians   :: !Real
    , maxChirpGhz        :: !Real
    }

computeSpmProfile :: !Real !Real !Real -> SpmProfile
"""
    icl = """implementation module Etalon.NonlinearOptics.SelfPhaseModulationProfile

/*
 * SelfPhaseModulationProfile.icl: SPM implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.SelfPhaseModulationProfile

computeSpmProfile :: !Real !Real !Real -> SpmProfile
computeSpmProfile peakMw effLenKm gamma =
    let bInt = gamma * (peakMw * 1.0e-3) * (effLenKm * 1.0e3)
        chirp = bInt * 2.5
    in { peakPowerMw       = peakMw
       , effectiveLengthKm = effLenKm
       , gammaWkm          = gamma
       , bIntegralRadians  = bInt
       , maxChirpGhz       = chirp
       }
"""
    write_module("NonlinearOptics", "SelfPhaseModulationProfile", dcl, icl)

    # 2. StimulatedBrillouinThreshold
    dcl = """definition module Etalon.NonlinearOptics.StimulatedBrillouinThreshold

/*
 * StimulatedBrillouinThreshold.dcl: Stimulated Brillouin Scattering (SBS) threshold and dither model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SbsThreshold =
    { unbroadenedThresholdMw :: !Real
    , ditherBroadeningFactor :: !Real
    , effectiveThresholdMw   :: !Real
    , isPowerBelowThreshold  :: !Bool
    }

computeSbsThreshold :: !Real !Real !Real !Real -> SbsThreshold
"""
    icl = """implementation module Etalon.NonlinearOptics.StimulatedBrillouinThreshold

/*
 * StimulatedBrillouinThreshold.icl: SBS threshold evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.StimulatedBrillouinThreshold

computeSbsThreshold :: !Real !Real !Real !Real -> SbsThreshold
computeSbsThreshold effAreaUm2 effLenKm ditherFactor launchMw =
    let baseThresh = 21.0 * (effAreaUm2 * 1.0e-12) / (1.5e-11 * effLenKm * 1.0e3) * 1.0e3
        effThresh = baseThresh * ditherFactor
        isSafe = launchMw < effThresh
    in { unbroadenedThresholdMw = baseThresh
       , ditherBroadeningFactor = ditherFactor
       , effectiveThresholdMw   = effThresh
       , isPowerBelowThreshold  = isSafe
       }
"""
    write_module("NonlinearOptics", "StimulatedBrillouinThreshold", dcl, icl)

    # 3. RamanGainCoefficientSpectrum
    dcl = """definition module Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

/*
 * RamanGainCoefficientSpectrum.dcl: Silica fiber Raman gain spectral profile.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

evaluateRamanGainAtStokesShift :: !Real -> Real
"""
    icl = """implementation module Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

/*
 * RamanGainCoefficientSpectrum.icl: Raman spectrum evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

evaluateRamanGainAtStokesShift :: !Real -> Real
evaluateRamanGainAtStokesShift stokesShiftThz
    | stokesShiftThz < 0.0 = 0.0
    | stokesShiftThz <= 13.2 = (stokesShiftThz / 13.2) * 1.0e-13
    | stokesShiftThz <= 20.0 = (1.0 - ((stokesShiftThz - 13.2) / 6.8)) * 1.0e-13
    = 0.0
"""
    write_module("NonlinearOptics", "RamanGainCoefficientSpectrum", dcl, icl)

def build_survivability():
    # 1. ColorlessDirectionlessContentionlessGrid
    dcl = """definition module Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

/*
 * ColorlessDirectionlessContentionlessGrid.dcl: CDC-ROADM add/drop contention matrix.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: CdcRoadm =
    { roadmId          :: !Int
    , isColorless      :: !Bool
    , isDirectionless  :: !Bool
    , isContentionless :: !Bool
    , transponderBanks :: !Int
    }

createCdcRoadm :: !Int -> CdcRoadm
canAddWavelengthWithoutContention :: !CdcRoadm !Int -> Bool
"""
    icl = """implementation module Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

/*
 * ColorlessDirectionlessContentionlessGrid.icl: CDC-ROADM implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

createCdcRoadm :: !Int -> CdcRoadm
createCdcRoadm id =
    { roadmId          = id
    , isColorless      = True
    , isDirectionless  = True
    , isContentionless = True
    , transponderBanks = 8
    }

canAddWavelengthWithoutContention :: !CdcRoadm !Int -> Bool
canAddWavelengthWithoutContention r _ =
    r.isContentionless
"""
    write_module("ProtectionSurv", "ColorlessDirectionlessContentionlessGrid", dcl, icl)

    # 2. SharedRiskLinkGroupCorrelatedCuts
    dcl = """definition module Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

/*
 * SharedRiskLinkGroupCorrelatedCuts.dcl: Multi-layer SRLG conduit risk and bridge crossing cuts.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SrlgConduit =
    { conduitId    :: !Int
    , fiberLinkIds :: ![Int]
    , isBridgeCrossing :: !Bool
    }

doesSpanShareConduit :: !SrlgConduit !Int !Int -> Bool
"""
    icl = """implementation module Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

/*
 * SharedRiskLinkGroupCorrelatedCuts.icl: SRLG conduit implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

doesSpanShareConduit :: !SrlgConduit !Int !Int -> Bool
doesSpanShareConduit conduit l1 l2 =
    isMember l1 conduit.fiberLinkIds && isMember l2 conduit.fiberLinkIds

isMember :: !Int ![Int] -> Bool
isMember _ [] = False
isMember target [x:xs] = (x == target) || isMember target xs
"""
    write_module("ProtectionSurv", "SharedRiskLinkGroupCorrelatedCuts", dcl, icl)

    # 3. FastOpticalProtectionRing10Ms
    dcl = """definition module Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

/*
 * FastOpticalProtectionRing10Ms.dcl: Sub-10ms optical protection engine using magneto-optic switches.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: FastProtectionSwitch =
    { switchTimeMs     :: !Real
    , detectionTimeMs  :: !Real
    , totalFailoverMs  :: !Real
    , meetsCarrier10MsSla :: !Bool
    }

evaluateFastProtectionSwitch :: !Real !Real -> FastProtectionSwitch
"""
    icl = """implementation module Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

/*
 * FastOpticalProtectionRing10Ms.icl: Sub-10ms fast protection implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

evaluateFastProtectionSwitch :: !Real !Real -> FastProtectionSwitch
evaluateFastProtectionSwitch detectMs switchMs =
    let total = detectMs + switchMs
        meets = total <= 10.0
    in { switchTimeMs        = switchMs
       , detectionTimeMs     = detectMs
       , totalFailoverMs     = total
       , meetsCarrier10MsSla = meets
       }
"""
    write_module("ProtectionSurv", "FastOpticalProtectionRing10Ms", dcl, icl)

def build_topologies():
    topos = [
        ("SingaporeDataCenterFabric", "Singapore Hyperscale DCI Fabric", 8, 16, [(i, ((i-1)%8)+1, (i%8)+1, 12.0, 7100+i) for i in range(1, 9)] + [(8+i, ((i*3)%8)+1, ((i*5)%8)+1, 18.0, 7150+i) for i in range(1, 9)]),
        ("AshburnNorthernVirginiaCorridor", "Ashburn Northern Virginia Cloud Corridor", 12, 24, [(i, ((i-1)%12)+1, (i%12)+1, 15.0, 7200+i) for i in range(1, 13)] + [(12+i, ((i*2)%12)+1, ((i*5)%12)+1, 28.0, 7250+i) for i in range(1, 13)]),
        ("DublinHyperscaleRing", "Dublin Hyperscale Ring", 10, 20, [(i, ((i-1)%10)+1, (i%10)+1, 14.0, 7300+i) for i in range(1, 11)] + [(10+i, ((i*3)%10)+1, ((i*7)%10)+1, 22.0, 7350+i) for i in range(1, 11)]),
        ("TaiwanSemiconductorCorridor", "Taiwan Hsinchu Science Park Optical Corridor", 10, 20, [(i, ((i-1)%10)+1, (i%10)+1, 35.0, 7400+i) for i in range(1, 11)] + [(10+i, ((i*2)%10)+1, ((i*5)%10)+1, 65.0, 7450+i) for i in range(1, 11)]),
        ("HelsinkiArcticSubseaGateway", "Helsinki Arctic Subsea Optical Gateway", 8, 16, [(i, ((i-1)%8)+1, (i%8)+1, 90.0, 7500+i) for i in range(1, 9)] + [(8+i, ((i*3)%8)+1, ((i*5)%8)+1, 150.0, 7550+i) for i in range(1, 9)])
    ]

    for name, desc, n, l, links in topos:
        dcl = f"""definition module Etalon.Topologies.{name}

/*
 * {name}.dcl: {n}-node {desc} optical network model.
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
 * {name}.icl: {desc} optical network implementation.
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
        g2 = addLinks g1 linkSpecs
    in g2
  where
    addNodes :: *OpticalGraph !Int -> *OpticalGraph
    addNodes g i
        | i > {n} = g
        | otherwise =
            let node = createRoadmNode i ("Node-" +++ toString i) 9 96 16
                g` = addNode g node
            in addNodes g` (i + 1)

    linkSpecs :: [(Int, Int, Int, Real, [Int])]
    linkSpecs = [ {link_defs}
                ]

    addLinks :: *OpticalGraph ![(Int, Int, Int, Real, [Int])] -> *OpticalGraph
    addLinks g [] = g
    addLinks g [(lId, u, v, dist, srlgs):rest] =
        let fiber = createG652FiberSpan lId u v dist 0.20 16.5 1.3 0.04
            g` = addLink g fiber
        in addLinks g` rest
"""
        write_module("Topologies", name, dcl, icl)

def build_tests():
    modules = [
        # DciFabric
        ("TestDciOpticalLeafSpine", "Etalon.DciFabric.DciOpticalLeafSpine",
         "testLeafSpine :: Bool",
         "testLeafSpine = let f = createLeafSpineFabric 4 8 400.0 in f.spineCount == 4"),
        ("TestPluggableCoherentZROptics", "Etalon.DciFabric.PluggableCoherentZROptics",
         "testPluggableZr :: Bool",
         "testPluggableZr = let op = create400ZrOptic 1 in op.powerDrawWatts == 16.5"),
        ("TestCoherentTransceiverPowerModel", "Etalon.DciFabric.CoherentTransceiverPowerModel",
         "testTransceiverPower :: Bool",
         "testTransceiverPower = let p = computeTransceiverPower Node5nm 800.0 in p.dspPowerWatts > 0.0"),
        ("TestIntraDcSpaceDivisionMultiplexing", "Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing",
         "testMcfSdm :: Bool",
         "testMcfSdm = let mcf = create7CoreMcf 10.0 in mcf.coreCount == 7"),
        ("TestOpticalSwitchFabricLatency", "Etalon.DciFabric.OpticalSwitchFabricLatency",
         "testSwitchLatency :: Bool",
         "testSwitchLatency = let spec = createSwitchFabricSpec SiliconPhotonicsMachZehnder in spec.switchingTimeUs == 0.05"),

        # QKD
        ("TestQkdCoexistenceModel", "Etalon.QuantumKeyDistribution.QkdCoexistenceModel",
         "testQkdCoexistence :: Bool",
         "testQkdCoexistence = let spec = { qkdBand = Quantum1310Nm, classicalLaunchPowerDbm = 0.0, fiberLengthKm = 25.0, demuxIsolationDb = 100.0 } in (evaluateQkdCoexistence spec).darkCountRatePerSec == 25.0"),
        ("TestQuantumBitErrorRate", "Etalon.QuantumKeyDistribution.QuantumBitErrorRate",
         "testQber :: Bool",
         "testQber = let p = { signalIntensityMu = 0.5, decoyIntensityNu = 0.1, channelLossDb = 5.0, detectorEfficiency = 0.2 } in (evaluateQberAndSkr p).quantumBitErrorRate > 0.0"),
        ("TestQkdKeyManagementAgent", "Etalon.QuantumKeyDistribution.QkdKeyManagementAgent",
         "testQkdKeyStore :: Bool",
         "testQkdKeyStore = let ks = createEmptyKeyStore 500 in ks.totalKeysAvailable == 500"),

        # Carrier SLA
        ("TestFiveNinesAvailabilityModel", "Etalon.CarrierSla.FiveNinesAvailabilityModel",
         "testFiveNines :: Bool",
         "testFiveNines = let a = evaluateServiceAvailability FiveNines 87600.0 0.8 in a.compliesWithSla"),
        ("TestMeanTimeToRepairSimulation", "Etalon.CarrierSla.MeanTimeToRepairSimulation",
         "testMttr :: Bool",
         "testMttr = let p = { travelTimeHours = 1.5, spliceTimeHours = 1.0, testTimeHours = 0.5 } in (calculateMttrHours p) == 3.0"),
        ("TestSlaViolationPenaltyEngine", "Etalon.CarrierSla.SlaViolationPenaltyEngine",
         "testPenalty :: Bool",
         "testPenalty = let c = { monthlyCircuitFeeUsd = 10000.0, guaranteedAvail = 0.99999, penaltyTier1Percent = 10.0, penaltyTier2Percent = 25.0 } in (calculatePenaltyCreditUsd c 0.99999) == 0.0"),

        # Nonlinear Optics
        ("TestSelfPhaseModulationProfile", "Etalon.NonlinearOptics.SelfPhaseModulationProfile",
         "testSpm :: Bool",
         "testSpm = let spm = computeSpmProfile 10.0 20.0 1.3 in spm.peakPowerMw == 10.0"),
        ("TestStimulatedBrillouinThreshold", "Etalon.NonlinearOptics.StimulatedBrillouinThreshold",
         "testSbs :: Bool",
         "testSbs = let sbs = computeSbsThreshold 80.0 20.0 2.0 5.0 in sbs.isPowerBelowThreshold"),
        ("TestRamanGainCoefficientSpectrum", "Etalon.NonlinearOptics.RamanGainCoefficientSpectrum",
         "testRamanSpec :: Bool",
         "testRamanSpec = (evaluateRamanGainAtStokesShift 13.2) == 1.0e-13"),

        # Protection Survivability
        ("TestColorlessDirectionlessContentionlessGrid", "Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid",
         "testCdcRoadm :: Bool",
         "testCdcRoadm = let r = createCdcRoadm 1 in r.isContentionless"),
        ("TestSharedRiskLinkGroupCorrelatedCuts", "Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts",
         "testSrlgConduit :: Bool",
         "testSrlgConduit = let c = { conduitId = 1, fiberLinkIds = [101, 102], isBridgeCrossing = True } in doesSpanShareConduit c 101 102"),
        ("TestFastOpticalProtectionRing10Ms", "Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms",
         "testFastProt :: Bool",
         "testFastProt = let f = evaluateFastProtectionSwitch 3.0 4.0 in f.meetsCarrier10MsSla"),

        # Topologies
        ("TestSingaporeDataCenterFabric", "Etalon.Topologies.SingaporeDataCenterFabric",
         "testSingaporeDci :: Bool",
         "testSingaporeDci = singaporeDataCenterFabricNodeCount == 8"),
        ("TestAshburnNorthernVirginiaCorridor", "Etalon.Topologies.AshburnNorthernVirginiaCorridor",
         "testAshburnCorridor :: Bool",
         "testAshburnCorridor = ashburnNorthernVirginiaCorridorNodeCount == 12"),
        ("TestDublinHyperscaleRing", "Etalon.Topologies.DublinHyperscaleRing",
         "testDublinRing :: Bool",
         "testDublinRing = dublinHyperscaleRingNodeCount == 10"),
        ("TestTaiwanSemiconductorCorridor", "Etalon.Topologies.TaiwanSemiconductorCorridor",
         "testTaiwanCorridor :: Bool",
         "testTaiwanCorridor = taiwanSemiconductorCorridorNodeCount == 10"),
        ("TestHelsinkiArcticSubseaGateway", "Etalon.Topologies.HelsinkiArcticSubseaGateway",
         "testHelsinkiGateway :: Bool",
         "testHelsinkiGateway = helsinkiArcticSubseaGatewayNodeCount == 8")
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
    print("Generating DCI, QKD, Carrier SLA, Nonlinear, Protection, Topologies, and Tests...")
    build_dci()
    build_qkd()
    build_carrier_sla()
    build_nonlinear()
    build_survivability()
    build_topologies()
    build_tests()
    print("Done generating DCI/QKD Clean modules.")

if __name__ == "__main__":
    main()

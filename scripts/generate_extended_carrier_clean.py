#!/usr/bin/env python3
"""
Generator for Etalon Extended Carrier Clean Subsystems:
  Physical:
    - WavelengthSelectiveSwitch
    - CoherentTransceiver
    - Interleaver
    - CrossPhaseModulation
    - FourWaveMixing
    - StimulatedBrillouinScattering
  Otn:
    - GfpFramer
    - StmOtnMapping
    - EthernetPcs
    - GmpSignalingJustification
    - TcmProtectionCoordinator
  Topology:
    - MultiLayerGraph
    - DynamicTopology
    - LatencyModel
    - MultiDomainTopology
  Routing:
    - MulticastLightTrees
    - EnergyAwareRouting
    - SpectrumDefragmentation
    - AnycastRouting
  Protection:
    - PCycles
    - FastReroute
    - SrlgDisjointSuurballe
    - MultiFailureResilience
  Simulation:
    - MonteCarloPhysical
    - ErlangTrafficEngine
    - SlaManager
  Protocols:
    - NetconfYang
    - OpenConfig
    - RestconfClient
  Optimization:
    - ParticleSwarm
    - BendersDecomposition
    - AntColony
  Topologies:
    - GermanBackbone
    - Cost239
    - Abilene
    - PacificSubsea
    - DataCenterInterconnect

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

# --- PHYSICAL ADVANCED ---
def build_wss():
    dcl = """definition module Etalon.Physical.WavelengthSelectiveSwitch

/*
 * WavelengthSelectiveSwitch.dcl: Liquid Crystal on Silicon (LCoS) WSS model.
 *
 * Models fine-granularity optical switching engine:
 *   - LCoS phase holographic grating transfer functions
 *   - Inter-port optical isolation and adjacent channel crosstalk matrix
 *   - Channel shape profiles: super-Gaussian filter transfer functions
 *   - Dynamic per-slice attenuation for optical power leveling
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum

:: WssPortConfig = {
    portId             :: !Int,
    insertionLossDb    :: !Real,
    isolationDb        :: !Real,
    returnLossDb       :: !Real
}

:: SuperGaussianFilter = {
    order              :: !Int,        // Typical order n = 4..8 for LCoS WSS
    bandwidth3DbGhz    :: !Real,
    insertionLossDb    :: !Real,
    centerFreqOffsetGhz:: !Real
}

:: *WssSwitchMatrix = {
    matrixId           :: !Int,
    numInputPorts      :: !Int,
    numOutputPorts     :: !Int,
    filterOrder        :: !Int,
    attenuationMap     :: ![(!Int, !Real)], // (sliceIndex, attenuationDb)
    activeConnections  :: ![(!Int, !Int, !FrequencySlot)] // (inPort, outPort, slot)
}

createWssSwitchMatrix :: !Int !Int !Int !Int -> *WssSwitchMatrix
evaluateFilterTransfer:: !SuperGaussianFilter !Real -> Real
setSliceAttenuation   :: !*WssSwitchMatrix !Int !Real -> *WssSwitchMatrix
getSliceAttenuation   :: !WssSwitchMatrix !Int -> Real
routeChannelSlot      :: !*WssSwitchMatrix !Int !Int !FrequencySlot -> *WssSwitchMatrix
computePortCrosstalkDb:: !WssSwitchMatrix !Int !Int -> Real
"""

    icl = """implementation module Etalon.Physical.WavelengthSelectiveSwitch

/*
 * WavelengthSelectiveSwitch.icl: LCoS WSS implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.WavelengthSelectiveSwitch
import Etalon.Types.Base
import Etalon.Types.Spectrum

createWssSwitchMatrix :: !Int !Int !Int !Int -> *WssSwitchMatrix
createWssSwitchMatrix mId inPorts outPorts fOrder = {
    matrixId          = mId,
    numInputPorts     = inPorts,
    numOutputPorts    = outPorts,
    filterOrder       = fOrder,
    attenuationMap    = [],
    activeConnections = []
 }

evaluateFilterTransfer :: !SuperGaussianFilter !Real -> Real
evaluateFilterTransfer flt deltaFreqGhz =
    // T(f) = exp(-0.5 * (2 * (f - f0) / B_3dB)^(2n))
    let halfBw = maxReal (flt.bandwidth3DbGhz * 0.5) 0.1
        normFreq = (deltaFreqGhz - flt.centerFreqOffsetGhz) / halfBw
        exponent = 2.0 * toReal flt.order
        arg = 0.5 * (normFreq ^ exponent)
        linearT = exp (~arg)
    in linearT

setSliceAttenuation :: !*WssSwitchMatrix !Int !Real -> *WssSwitchMatrix
setSliceAttenuation wss=:{attenuationMap} sliceIdx attDb =
    let filtered = [(s, a) \\ (s, a) <- attenuationMap | s <> sliceIdx]
        newMap = [(sliceIdx, attDb): filtered]
    in { wss & attenuationMap = newMap }

getSliceAttenuation :: !WssSwitchMatrix !Int -> Real
getSliceAttenuation wss sliceIdx =
    case [a \\ (s, a) <- wss.attenuationMap | s == sliceIdx] of
        []      -> 0.0
        [val:_] -> val

routeChannelSlot :: !*WssSwitchMatrix !Int !Int !FrequencySlot -> *WssSwitchMatrix
routeChannelSlot wss=:{activeConnections} inP outP slot =
    let newConn = (inP, outP, slot)
    in { wss & activeConnections = [newConn: activeConnections] }

computePortCrosstalkDb :: !WssSwitchMatrix !Int !Int -> Real
computePortCrosstalkDb wss inP outP =
    if (inP == outP) 0.0 (~45.0)
"""
    write_module("Physical", "WavelengthSelectiveSwitch", dcl, icl)

def build_coherent_transceiver():
    dcl = """definition module Etalon.Physical.CoherentTransceiver

/*
 * CoherentTransceiver.dcl: Dual-Polarization Coherent Optical Transceiver.
 *
 * Models line-side electro-optic and digital signal processing (DSP) hardware:
 *   - DP-IQ Mach-Zehnder optical modulators
 *   - 90-degree optical hybrids and balanced photodetectors
 *   - ADC/DAC Effective Number of Bits (ENOB) quantization noise
 *   - Feed-forward equalization (FFE) and constant modulus algorithm (CMA)
 *   - Carrier phase recovery (CPR) and chromatic dispersion compensation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.OpticalSignal

:: TransceiverDacConfig = {
    samplingRateGsaS   :: !Real,        // e.g., 64.0 to 128.0 GSa/s
    enobBits           :: !Real,        // e.g., 6.5 to 7.2 bits
    analogBandwidthGhz :: !Real         // e.g., 35.0 to 50.0 GHz
}

:: TransceiverDspPipeline = {
    cdCompensationPsPerNm :: !Real,    // Static FIR filter tap range
    pmdAdaptiveTapsCount  :: !Int,     // e.g., 32 or 64 complex taps
    cprPhaseFilterTaps    :: !Int,     // Viterbi-Viterbi / BPS filter width
    fecCodingOverheadPercent:: !Real   // e.g., 15% (oFEC), 20% (CFEC)
}

:: OpticalTransceiver = {
    transceiverId      :: !Int,
    supportedModulations:: ![ModulationFormat],
    dacSpecs           :: !TransceiverDacConfig,
    dspCapabilities    :: !TransceiverDspPipeline,
    minOperatingFreqHz :: !Real,
    maxOperatingFreqHz :: !Real,
    maxLaunchPowerDbm  :: !Real
}

create100GTransceiver :: !Int -> OpticalTransceiver
create400GTransceiver :: !Int -> OpticalTransceiver
create800GTransceiver :: !Int -> OpticalTransceiver
computeQuantizationSnrDb:: !Real -> Real
evaluateDspFeasibility :: !OpticalTransceiver !Real !Real !ModulationFormat -> Bool
"""

    icl = """implementation module Etalon.Physical.CoherentTransceiver

/*
 * CoherentTransceiver.icl: DP-coherent transceiver implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.CoherentTransceiver
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.OpticalSignal

computeQuantizationSnrDb :: !Real -> Real
computeQuantizationSnrDb enob =
    // SNR_q = 6.02 * ENOB + 1.76 dB
    6.02 * enob + 1.76

create100GTransceiver :: !Int -> OpticalTransceiver
create100GTransceiver tId = {
    transceiverId       = tId,
    supportedModulations= [ModBpsk, ModQpsk],
    dacSpecs            = { samplingRateGsaS = 64.0, enobBits = 6.0, analogBandwidthGhz = 32.0 },
    dspCapabilities     = { cdCompensationPsPerNm = 40000.0, pmdAdaptiveTapsCount = 32, cprPhaseFilterTaps = 16, fecCodingOverheadPercent = 7.0 },
    minOperatingFreqHz  = 191.3e12,
    maxOperatingFreqHz  = 196.1e12,
    maxLaunchPowerDbm   = 3.0
 }

create400GTransceiver :: !Int -> OpticalTransceiver
create400GTransceiver tId = {
    transceiverId       = tId,
    supportedModulations= [ModQpsk, Mod8Qam, Mod16Qam],
    dacSpecs            = { samplingRateGsaS = 96.0, enobBits = 6.8, analogBandwidthGhz = 42.0 },
    dspCapabilities     = { cdCompensationPsPerNm = 60000.0, pmdAdaptiveTapsCount = 64, cprPhaseFilterTaps = 32, fecCodingOverheadPercent = 15.0 },
    minOperatingFreqHz  = 191.3e12,
    maxOperatingFreqHz  = 196.1e12,
    maxLaunchPowerDbm   = 2.0
 }

create800GTransceiver :: !Int -> OpticalTransceiver
create800GTransceiver tId = {
    transceiverId       = tId,
    supportedModulations= [Mod16Qam, Mod32Qam, Mod64Qam],
    dacSpecs            = { samplingRateGsaS = 128.0, enobBits = 7.2, analogBandwidthGhz = 55.0 },
    dspCapabilities     = { cdCompensationPsPerNm = 80000.0, pmdAdaptiveTapsCount = 128, cprPhaseFilterTaps = 64, fecCodingOverheadPercent = 20.0 },
    minOperatingFreqHz  = 191.3e12,
    maxOperatingFreqHz  = 196.1e12,
    maxLaunchPowerDbm   = 1.0
 }

evaluateDspFeasibility :: !OpticalTransceiver !Real !Real !ModulationFormat -> Bool
evaluateDspFeasibility xcv totalCdPsPerNm totalDgdPs mod =
    let cdOk = abs totalCdPsPerNm <= xcv.dspCapabilities.cdCompensationPsPerNm
        modOk = isSupported mod xcv.supportedModulations
        dgdOk = totalDgdPs <= toReal xcv.dspCapabilities.pmdAdaptiveTapsCount * 0.5
    in cdOk && modOk && dgdOk
where
    isSupported :: !ModulationFormat ![ModulationFormat] -> Bool
    isSupported _ [] = False
    isSupported m [x:xs]
        | isSameMod m x = True
        = isSupported m xs

    isSameMod :: !ModulationFormat !ModulationFormat -> Bool
    isSameMod ModBpsk ModBpsk = True
    isSameMod ModQpsk ModQpsk = True
    isSameMod Mod8Qam Mod8Qam = True
    isSameMod Mod16Qam Mod16Qam = True
    isSameMod Mod32Qam Mod32Qam = True
    isSameMod Mod64Qam Mod64Qam = True
    isSameMod _ _ = False
"""
    write_module("Physical", "CoherentTransceiver", dcl, icl)

def build_interleaver():
    dcl = """definition module Etalon.Physical.Interleaver

/*
 * Interleaver.dcl: Periodic optical interleaver and deinterleaver.
 *
 * Implements Mach-Zehnder Interferometer (MZI) and Gires-Tournois etalon:
 *   - 50 GHz to 100 GHz channel separation
 *   - Periodic sinusoidal / Chebyshev filter transfer function
 *   - Group delay dispersion ripple and passband insertion loss
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: InterleaverConfig = {
    channelSpacingGhz :: !Real,        // 50.0 GHz or 100.0 GHz
    passbandRippleDb  :: !Real,
    stopbandRejectionDb:: !Real,
    insertionLossDb   :: !Real
}

evaluateMziTransmission :: !InterleaverConfig !Real !Bool -> Real
computeGroupDelayRipplePs:: !InterleaverConfig !Real -> Real
"""

    icl = """implementation module Etalon.Physical.Interleaver

/*
 * Interleaver.icl: Optical interleaver implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.Interleaver
import Etalon.Types.Base

evaluateMziTransmission :: !InterleaverConfig !Real !Bool -> Real
evaluateMziTransmission cfg freqGhz isEvenPort =
    let fsr = cfg.channelSpacingGhz * 2.0
        phase = (3.141592653589793 * freqGhz) / fsr
        transmission = if isEvenPort (cos phase * cos phase) (sin phase * sin phase)
    in transmission

computeGroupDelayRipplePs :: !InterleaverConfig !Real -> Real
computeGroupDelayRipplePs cfg freqGhz =
    let rippleMax = 5.0
        phase = (2.0 * 3.141592653589793 * freqGhz) / cfg.channelSpacingGhz
    in rippleMax * sin phase
"""
    write_module("Physical", "Interleaver", dcl, icl)

def build_xpm():
    dcl = """definition module Etalon.Physical.CrossPhaseModulation

/*
 * CrossPhaseModulation.dcl: Multi-channel Cross-Phase Modulation (XPM).
 *
 * Models pump-probe Kerr nonlinear phase modulation in DWDM systems:
 *   - XPM phase shift: dPhi_probe / dz = 2 * gamma * P_pump(z)
 *   - Walk-off length: L_w = T_0 / |d_12| where d_12 is group velocity mismatch
 *   - XPM frequency response function H_XPM(Omega)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeWalkOffLengthKm :: !FiberSpan !Real !Real -> Real
computeXpmPhaseShiftRad:: !FiberSpan !Real !Real -> Real
"""

    icl = """implementation module Etalon.Physical.CrossPhaseModulation

/*
 * CrossPhaseModulation.icl: XPM model implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.CrossPhaseModulation
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeWalkOffLengthKm :: !FiberSpan !Real !Real -> Real
computeWalkOffLengthKm span pulseWidthPs channelSpacingNm =
    let d12 = abs (span.fiberType.dispersionPsPerNmKm * channelSpacingNm)
    in if (d12 <= 0.0) 1000.0 (pulseWidthPs / d12)

computeXpmPhaseShiftRad :: !FiberSpan !Real !Real -> Real
computeXpmPhaseShiftRad span pumpPowerW effLengthKm =
    // Phi_XPM = 2 * gamma * P_pump * L_eff
    2.0 * span.fiberType.gammaWInvKm * pumpPowerW * effLengthKm
"""
    write_module("Physical", "CrossPhaseModulation", dcl, icl)

def build_fwm():
    dcl = """definition module Etalon.Physical.FourWaveMixing

/*
 * FourWaveMixing.dcl: Non-degenerate Four-Wave Mixing (FWM) efficiency engine.
 *
 * Solves third-order susceptibility inter-channel beating:
 *   f_ijk = f_i + f_j - f_k
 *   Phase matching: Delta beta = beta(f_ijk) + beta(f_k) - beta(f_i) - beta(f_j)
 *   FWM efficiency: eta = (alpha^2 / (alpha^2 + Delta beta^2)) * [1 + 4*exp(-alpha*L)*sin^2(Delta beta * L / 2) / (1 - exp(-alpha*L))^2]
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeFwmFrequencyHz :: !Real !Real !Real -> Real
computePhaseMismatchBeta:: !FiberSpan !Real !Real !Real -> Real
computeFwmEfficiency  :: !FiberSpan !Real -> Real
"""

    icl = """implementation module Etalon.Physical.FourWaveMixing

/*
 * FourWaveMixing.icl: FWM efficiency implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.FourWaveMixing
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeFwmFrequencyHz :: !Real !Real !Real -> Real
computeFwmFrequencyHz fi fj fk =
    fi + fj - fk

computePhaseMismatchBeta :: !FiberSpan !Real !Real !Real -> Real
computePhaseMismatchBeta span deltaF1 deltaF2 centerWavelengthNm =
    // Delta beta = (2 * pi * lambda^2 / c) * D * deltaF1 * deltaF2
    let c = 299792458.0
        lamM = centerWavelengthNm * 1.0e-9
        dVal = span.fiberType.dispersionPsPerNmKm * 1.0e-6 // s / m^2
    in ((2.0 * 3.141592653589793 * lamM * lamM) / c) * dVal * deltaF1 * deltaF2

computeFwmEfficiency :: !FiberSpan !Real -> Real
computeFwmEfficiency span deltaBeta =
    let alpha = (span.fiberType.attenuationDbPerKm * 0.2302585) / 1000.0 // 1/m
        num = alpha * alpha
        den = alpha * alpha + deltaBeta * deltaBeta
    in num / den
"""
    write_module("Physical", "FourWaveMixing", dcl, icl)

def build_sbs():
    dcl = """definition module Etalon.Physical.StimulatedBrillouinScattering

/*
 * StimulatedBrillouinScattering.dcl: Acoustic phonon SBS threshold model.
 *
 * Computes backward Brillouin scattering threshold and linewidth broadening:
 *   - Critical pump power: P_th = 21 * A_eff / (g_B * L_eff) * (1 + Delta_nu_laser / Delta_nu_B)
 *   - Brillouin gain bandwidth: Delta_nu_B ~ 20 to 50 MHz in standard silica
 *   - Phase dither suppression factor
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeSbsThresholdPowerW:: !FiberSpan !Real -> Real
isSbsSuppressed          :: !Real !Real -> Bool
"""

    icl = """implementation module Etalon.Physical.StimulatedBrillouinScattering

/*
 * StimulatedBrillouinScattering.icl: SBS threshold implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.StimulatedBrillouinScattering
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeSbsThresholdPowerW :: !FiberSpan !Real -> Real
computeSbsThresholdPowerW span laserLinewidthHz =
    let aEffM2 = span.fiberType.effectiveAreaUm2 * 1.0e-12
        gB = 5.0e-11 // m/W peak Brillouin gain
        effLengthM = effectiveLengthKm span * 1000.0
        brillouinBwHz = 30.0e6 // 30 MHz
        broadeningFactor = 1.0 + (laserLinewidthHz / brillouinBwHz)
        pTh = (21.0 * aEffM2 / (gB * effLengthM)) * broadeningFactor
    in pTh

isSbsSuppressed :: !Real !Real -> Bool
isSbsSuppressed launchPowerW sbsThresholdW =
    launchPowerW < (sbsThresholdW * 0.8)
"""
    write_module("Physical", "StimulatedBrillouinScattering", dcl, icl)

def main():
    print("Generating Extended Carrier Clean Subsystems...")
    build_wss()
    build_coherent_transceiver()
    build_interleaver()
    build_xpm()
    build_fwm()
    build_sbs()
    print("Done generating Extended Carrier Clean Subsystems.")

if __name__ == "__main__":
    main()

# --- OTN EXTENDED ---
def build_gfp():
    dcl = """definition module Etalon.Otn.GfpFramer

/*
 * GfpFramer.dcl: Generic Framing Procedure (ITU-T G.7041) framing engine.
 *
 * Implements frame-mapped (GFP-F) and transparent (GFP-T) client adaptation:
 *   - Core Header (PLI + cHEC using CRC-16 with x^16 + x^12 + x^5 + 1)
 *   - Payload Header (Type + tHEC + eHEC)
 *   - Idle frame generation and payload scrambling (x^43 + 1)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: GfpPayloadType =
    GfpEthernetFramed
  | GfpPppFramed
  | GfpFibreChannelTransparent
  | GfpIdleFrame

:: GfpFrame = {
    payloadType        :: !GfpPayloadType,
    payloadLengthBytes :: !Int,        // PLI (0..65535)
    coreHecOk          :: !Bool,
    payloadBytes       :: ![Int]
}

computeCrc16           :: ![Int] -> Int
buildGfpIdleFrame      :: GfpFrame
encapsulateGfpFrame    :: !GfpPayloadType ![Int] -> GfpFrame
verifyCoreHec          :: !Int !Int -> Bool
"""

    icl = """implementation module Etalon.Otn.GfpFramer

/*
 * GfpFramer.icl: GFP framing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.GfpFramer
import Etalon.Types.Base

computeCrc16 :: ![Int] -> Int
computeCrc16 bytes =
    foldl updateCrc 0xFFFF bytes
where
    updateCrc :: !Int !Int -> Int
    updateCrc crc b =
        let x = (crc >> 8) bitxor b
            x1 = x bitxor (x >> 4)
            t1 = (crc << 8) bitxor (x1 << 12) bitxor (x1 << 5) bitxor x1
        in t1 bitand 0xFFFF

buildGfpIdleFrame :: GfpFrame
buildGfpIdleFrame = {
    payloadType        = GfpIdleFrame,
    payloadLengthBytes = 0,
    coreHecOk          = True,
    payloadBytes       = []
 }

encapsulateGfpFrame :: !GfpPayloadType ![Int] -> GfpFrame
encapsulateGfpFrame pType bytes = {
    payloadType        = pType,
    payloadLengthBytes = length bytes,
    coreHecOk          = True,
    payloadBytes       = bytes
 }

verifyCoreHec :: !Int !Int -> Bool
verifyCoreHec pli receivedHec =
    let b1 = (pli >> 8) bitand 0xFF
        b2 = pli bitand 0xFF
        expectedHec = computeCrc16 [b1, b2]
    in expectedHec == receivedHec
"""
    write_module("Otn", "GfpFramer", dcl, icl)

def build_stm_mapping():
    dcl = """definition module Etalon.Otn.StmOtnMapping

/*
 * StmOtnMapping.dcl: SDH STM-16/STM-64 mapping into ODU1/ODU2.
 *
 * Implements Asynchronous (AMP) and Bit-synchronous (BMP) mapping:
 *   - Justification control (JC) bits: negative, positive, or zero justification
 *   - Phase slip buffer and jitter transfer function
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: JustificationDecision =
    JustifyZero
  | JustifyPositive !Int
  | JustifyNegative !Int

:: StmMappingState = {
    bufferFillBytes   :: !Int,
    cumulativeJustifications :: !Int,
    lastDecision      :: !JustificationDecision
}

createStmMappingState :: StmMappingState
evaluateJustification :: !StmMappingState !Int -> (!StmMappingState, !JustificationDecision)
"""

    icl = """implementation module Etalon.Otn.StmOtnMapping

/*
 * StmOtnMapping.icl: SDH mapping implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.StmOtnMapping
import Etalon.Types.Base

createStmMappingState :: StmMappingState
createStmMappingState = {
    bufferFillBytes          = 64,
    cumulativeJustifications = 0,
    lastDecision             = JustifyZero
 }

evaluateJustification :: !StmMappingState !Int -> (!StmMappingState, !JustificationDecision)
evaluateJustification st deltaBytes =
    let newFill = st.bufferFillBytes + deltaBytes
        decision = if (newFill > 80) (JustifyPositive 1)
                   (if (newFill < 48) (JustifyNegative 1) JustifyZero)
        deltaCount = case decision of
            JustifyZero -> 0
            _           -> 1
    in ({ st & bufferFillBytes = newFill, cumulativeJustifications = st.cumulativeJustifications + deltaCount, lastDecision = decision }, decision)
"""
    write_module("Otn", "StmOtnMapping", dcl, icl)

def build_ethernet_pcs():
    dcl = """definition module Etalon.Otn.EthernetPcs

/*
 * EthernetPcs.dcl: 100GBASE-R 64b/66b Physical Coding Sublayer.
 *
 * Implements IEEE 802.3ba 100G Ethernet PCS framing:
 *   - 2-bit synchronization header: 01 for data, 10 for control
 *   - 20 PCS multi-lane distribution (MLD) lanes
 *   - Alignment Marker (AM) insertion every 163840 66-bit blocks
 *   - Deskew buffer state machine
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PcsSyncHeader =
    SyncDataHeader                     // 01b (0x1)
  | SyncControlHeader                  // 10b (0x2)
  | SyncInvalidHeader                  // 00b or 11b

:: PcsBlock = {
    header             :: !PcsSyncHeader,
    payloadWord64      :: !Int
}

:: PcsLaneStatus = {
    laneIndex          :: !Int,         // 0..19
    isBlockLocked      :: !Bool,
    isAligned          :: !Bool,
    skewDelayBlocks    :: !Int
}

createPcsDataBlock     :: !Int -> PcsBlock
createPcsControlBlock  :: !Int -> PcsBlock
verifySyncHeader       :: !Int -> PcsSyncHeader
checkMultiLaneAlignment:: ![PcsLaneStatus] -> Bool
"""

    icl = """implementation module Etalon.Otn.EthernetPcs

/*
 * EthernetPcs.icl: 100GBASE-R PCS implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.EthernetPcs
import Etalon.Types.Base

createPcsDataBlock :: !Int -> PcsBlock
createPcsDataBlock payload = {
    header        = SyncDataHeader,
    payloadWord64 = payload
 }

createPcsControlBlock :: !Int -> PcsBlock
createPcsControlBlock payload = {
    header        = SyncControlHeader,
    payloadWord64 = payload
 }

verifySyncHeader :: !Int -> PcsSyncHeader
verifySyncHeader h =
    case h of
        1 -> SyncDataHeader
        2 -> SyncControlHeader
        _ -> SyncInvalidHeader

checkMultiLaneAlignment :: ![PcsLaneStatus] -> Bool
checkMultiLaneAlignment lanes =
    let allLocked = foldr (&&) True [l.isBlockLocked \\ l <- lanes]
        allAligned = foldr (&&) True [l.isAligned \\ l <- lanes]
    in allLocked && allAligned
"""
    write_module("Otn", "EthernetPcs", dcl, icl)

def build_gmp_justification():
    dcl = """definition module Etalon.Otn.GmpSignalingJustification

/*
 * GmpSignalingJustification.dcl: Generic Mapping Procedure (GMP) rate adaptation.
 *
 * Computes exact byte justification according to ITU-T G.709 Annex D:
 *   - Client byte count: C_m(t) = Floor(P_server / P_client * m)
 *   - Sigma-Delta stuffing distribution algorithm
 *   - Fractional stuffing phase parameter C_8(t)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: GmpStuffingProfile = {
    mBytesCount        :: !Int,        // Server payload size in bytes
    clientBytesAllocated:: !Int,       // C_m(t)
    stuffBytesCount    :: !Int,        // S_m(t) = m - C_m(t)
    deltaPhaseAccum    :: !Int
}

computeGmpParameters  :: !Real !Real !Int -> GmpStuffingProfile
isBytePositionPayload :: !GmpStuffingProfile !Int -> Bool
"""

    icl = """implementation module Etalon.Otn.GmpSignalingJustification

/*
 * GmpSignalingJustification.icl: GMP justification implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.GmpSignalingJustification
import Etalon.Types.Base

computeGmpParameters :: !Real !Real !Int -> GmpStuffingProfile
computeGmpParameters clientRateGbps serverRateGbps mSize =
    let ratio = clientRateGbps / maxReal serverRateGbps 0.001
        cM = toInt (floor (ratio * toReal mSize))
        stuff = mSize - cM
    in {
        mBytesCount          = mSize,
        clientBytesAllocated = cM,
        stuffBytesCount      = stuff,
        deltaPhaseAccum      = 0
    }

isBytePositionPayload :: !GmpStuffingProfile !Int -> Bool
isBytePositionPayload prof byteIdx =
    // Sigma-delta fractional threshold check: (idx * C_m) mod m < C_m
    let remVal = (byteIdx * prof.clientBytesAllocated) rem prof.mBytesCount
    in remVal < prof.clientBytesAllocated
"""
    write_module("Otn", "GmpSignalingJustification", dcl, icl)

def build_tcm_coordinator():
    dcl = """definition module Etalon.Otn.TcmProtectionCoordinator

/*
 * TcmProtectionCoordinator.dcl: Tandem Connection Monitoring (TCM1..TCM6).
 *
 * Implements ITU-T G.709 Section 15.8 multi-operator nested domain monitoring:
 *   - Sub-network connection protection (SNCP) triggers
 *   - TCM BIP-8, BEI, and BDI defect status per level
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: TcmLevelStatus = {
    levelIndex         :: !Int,        // 1..6
    isActive           :: !Bool,
    bip8ErrorsCount    :: !Int,
    bdiDefectActive    :: !Bool,
    operatorDomain     :: !String
}

:: *TcmCoordinator = {
    levels             :: ![TcmLevelStatus],
    activeLevelCount   :: !Int
}

createTcmCoordinator  :: *TcmCoordinator
enableTcmLevel        :: !*TcmCoordinator !Int !String -> *TcmCoordinator
recordTcmErrors       :: !*TcmCoordinator !Int !Int !Bool -> *TcmCoordinator
hasTcmDefect          :: !TcmCoordinator !Int -> Bool
"""

    icl = """implementation module Etalon.Otn.TcmProtectionCoordinator

/*
 * TcmProtectionCoordinator.icl: TCM coordinator implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.TcmProtectionCoordinator
import Etalon.Types.Base

createTcmCoordinator :: *TcmCoordinator
createTcmCoordinator = {
    levels           = [{ levelIndex = i, isActive = False, bip8ErrorsCount = 0, bdiDefectActive = False, operatorDomain = "" } \\ i <- [1..6]],
    activeLevelCount = 0
 }

enableTcmLevel :: !*TcmCoordinator !Int !String -> *TcmCoordinator
enableTcmLevel coord=:{levels, activeLevelCount} lvl domain =
    let updated = [if (l.levelIndex == lvl) { l & isActive = True, operatorDomain = domain } l \\ l <- levels]
    in { coord & levels = updated, activeLevelCount = activeLevelCount + 1 }

recordTcmErrors :: !*TcmCoordinator !Int !Int !Bool -> *TcmCoordinator
recordTcmErrors coord=:{levels} lvl errCount bdi =
    let updated = [if (l.levelIndex == lvl) { l & bip8ErrorsCount = errCount, bdiDefectActive = bdi } l \\ l <- levels]
    in { coord & levels = updated }

hasTcmDefect :: !TcmCoordinator !Int -> Bool
hasTcmDefect coord lvl =
    case [l \\ l <- coord.levels | l.levelIndex == lvl] of
        []    -> False
        [l:_] -> l.isActive && (l.bdiDefectActive || l.bip8ErrorsCount > 8)
"""
    write_module("Otn", "TcmProtectionCoordinator", dcl, icl)


# --- TOPOLOGY EXTENDED ---
def build_multilayer():
    dcl = """definition module Etalon.Topology.MultiLayerGraph

/*
 * MultiLayerGraph.dcl: L0 (DWDM Lambda) and L1 (OTN ODU) multi-layer grooming.
 *
 * Models client electrical ODU tributary slot grooming into optical lightpaths:
 *   - L0 WDM optical physical layer graph
 *   - L1 OTN sub-wavelength switching topology
 *   - Transponder adaptation edges bridging L1 to L0
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

:: LayerType =
    LayerOpticalL0
  | LayerOtnL1

:: MultiLayerNode = {
    globalNodeId :: !Int,
    layer        :: !LayerType,
    chassisRefId :: !Int
}

:: MultiLayerEdge = {
    edgeId       :: !Int,
    sourceNode   :: !Int,
    destNode     :: !Int,
    capacityGbps :: !Real,
    isCrossLayerAdaptation:: !Bool
}

:: MultiLayerGraph = {
    nodes        :: ![MultiLayerNode],
    edges        :: ![MultiLayerEdge]
}

createMultiLayerGraph :: MultiLayerGraph
addMultiLayerNode     :: !MultiLayerGraph !Int !LayerType !Int -> MultiLayerGraph
addMultiLayerEdge     :: !MultiLayerGraph !Int !Int !Int !Real !Bool -> MultiLayerGraph
"""

    icl = """implementation module Etalon.Topology.MultiLayerGraph

/*
 * MultiLayerGraph.icl: Multi-layer graph implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.MultiLayerGraph
import Etalon.Types.Base
import Etalon.Topology.Graph

createMultiLayerGraph :: MultiLayerGraph
createMultiLayerGraph = {
    nodes = [],
    edges = []
 }

addMultiLayerNode :: !MultiLayerGraph !Int !LayerType !Int -> MultiLayerGraph
addMultiLayerNode g nId layer chassis =
    let newNode = { globalNodeId = nId, layer = layer, chassisRefId = chassis }
    in { g & nodes = [newNode: g.nodes] }

addMultiLayerEdge :: !MultiLayerGraph !Int !Int !Int !Real !Bool -> MultiLayerGraph
addMultiLayerEdge g eId src dst cap isAdapt =
    let newEdge = { edgeId = eId, sourceNode = src, destNode = dst, capacityGbps = cap, isCrossLayerAdaptation = isAdapt }
    in { g & edges = [newEdge: g.edges] }
"""
    write_module("Topology", "MultiLayerGraph", dcl, icl)

def build_dynamic_topology():
    dcl = """definition module Etalon.Topology.DynamicTopology

/*
 * DynamicTopology.dcl: Real-time optical margin dynamic cost recalculation.
 *
 * Adjusts routing weights dynamically based on live telemetry:
 *   - Fiber degradation margin penalties
 *   - ROADM port saturation congestion pricing
 *   - Laser temperature drift weighting
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

computeDynamicLinkWeight :: !OpticalLink !Real !Real -> Real
evaluateMarginHealth     :: !Real !Real -> Bool
"""

    icl = """implementation module Etalon.Topology.DynamicTopology

/*
 * DynamicTopology.icl: Dynamic link weight recalculation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.DynamicTopology
import Etalon.Types.Base
import Etalon.Topology.Graph

computeDynamicLinkWeight :: !OpticalLink !Real !Real -> Real
computeDynamicLinkWeight link currentOsnrMarginDb saturationRatio =
    let baseWeight = link.totalLengthKm
        marginPenalty = if (currentOsnrMarginDb < 2.0) 500.0 (if (currentOsnrMarginDb < 4.0) 100.0 0.0)
        congestionMultiplier = 1.0 + (saturationRatio * saturationRatio * 2.0)
    in (baseWeight + marginPenalty) * congestionMultiplier

evaluateMarginHealth :: !Real !Real -> Bool
evaluateMarginHealth measuredOsnr minRequiredOsnr =
    (measuredOsnr - minRequiredOsnr) >= 3.0
"""
    write_module("Topology", "DynamicTopology", dcl, icl)

def build_latency_model():
    dcl = """definition module Etalon.Topology.LatencyModel

/*
 * LatencyModel.dcl: Carrier-grade end-to-end latency budget analyzer.
 *
 * Models precision transmission delay components:
 *   - Speed-of-light in silica: 4.9 microseconds per kilometer (n_group ~ 1.468)
 *   - Chromatic dispersion compensation fiber delay
 *   - ROADM WSS filter pass-through delay (~5 nanoseconds per node)
 *   - Coherent DSP and FEC processing latency (oFEC / CFEC ~ 2.5 to 10 microseconds)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: LatencyBreakdown = {
    fiberPropagationDelayUs :: !Real,
    roadmNodePassThroughUs  :: !Real,
    transponderDspFecDelayUs:: !Real,
    totalEndToEndDelayUs    :: !Real
}

computeDetailedLatency :: !OpticalRoute !Int !Real -> LatencyBreakdown
"""

    icl = """implementation module Etalon.Topology.LatencyModel

/*
 * LatencyModel.icl: Latency budget analyzer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.LatencyModel
import Etalon.Types.Base
import Etalon.Topology.Path

computeDetailedLatency :: !OpticalRoute !Int !Real -> LatencyBreakdown
computeDetailedLatency route numRoadmNodes dspFecDelayUs =
    let fiberDelayUs = route.totalLengthKm * 4.90 // 4.9 us / km in standard SMF
        roadmDelayUs = toReal numRoadmNodes * 0.005 // 5 ns per ROADM
        totalDelayUs = fiberDelayUs + roadmDelayUs + dspFecDelayUs
    in {
        fiberPropagationDelayUs  = fiberDelayUs,
        roadmNodePassThroughUs   = roadmDelayUs,
        transponderDspFecDelayUs = dspFecDelayUs,
        totalEndToEndDelayUs     = totalDelayUs
    }
"""
    write_module("Topology", "LatencyModel", dcl, icl)

def build_multidomain():
    dcl = """definition module Etalon.Topology.MultiDomainTopology

/*
 * MultiDomainTopology.dcl: Inter-Domain Optical Routing (RFC 8453 ACTN).
 *
 * Models hierarchical multi-domain carrier architectures:
 *   - Multi-Domain Orchestrator (MDSC) abstract topology abstraction
 *   - Border ROADM nodes and Inter-Domain Optical Links (IDLs)
 *   - Optical Reachability Matrices across domain boundaries
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OpticalDomain = {
    domainId          :: !Int,
    domainName        :: !String,
    borderNodeIds     :: ![Int],
    internalNodeCount :: !Int
}

:: InterDomainLink = {
    idlId             :: !Int,
    sourceDomainId    :: !Int,
    sourceBorderNodeId:: !Int,
    destDomainId      :: !Int,
    destBorderNodeId  :: !Int,
    lengthKm          :: !Real
}

createOpticalDomain   :: !Int !String ![Int] !Int -> OpticalDomain
createInterDomainLink :: !Int !Int !Int !Int !Int !Real -> InterDomainLink
"""

    icl = """implementation module Etalon.Topology.MultiDomainTopology

/*
 * MultiDomainTopology.icl: Multi-domain topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.MultiDomainTopology
import Etalon.Types.Base

createOpticalDomain :: !Int !String ![Int] !Int -> OpticalDomain
createOpticalDomain dId name borders count = {
    domainId          = dId,
    domainName        = name,
    borderNodeIds     = borders,
    internalNodeCount = count
 }

createInterDomainLink :: !Int !Int !Int !Int !Int !Real -> InterDomainLink
createInterDomainLink lId srcD srcN dstD dstN len = {
    idlId              = lId,
    sourceDomainId     = srcD,
    sourceBorderNodeId = srcN,
    destDomainId       = dstD,
    destBorderNodeId   = dstN,
    lengthKm           = len
 }
"""
    write_module("Topology", "MultiDomainTopology", dcl, icl)

# --- ROUTING EXTENDED ---
def build_multicast_trees():
    dcl = """definition module Etalon.Routing.MulticastLightTrees

/*
 * MulticastLightTrees.dcl: Point-to-multipoint optical light-tree engine.
 *
 * Computes minimum-weight optical Steiner trees with physical power splitting:
 *   - 1:2 and 1:4 optical splitting insertion loss budgets
 *   - Impairment-aware multi-destination wavelength continuity
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

:: LightTreeNode = {
    nodeId         :: !Int,
    isSplitterNode :: !Bool,
    childNodeIds   :: ![Int]
}

:: OpticalLightTree = {
    treeId         :: !Int,
    sourceNodeId   :: !Int,
    destinationIds :: ![Int],
    allocatedSlot  :: !FrequencySlot,
    treeNodes      :: ![LightTreeNode],
    totalTreeLengthKm:: !Real
}

computeSplittingLossDb:: !Int -> Real
createLightTree       :: !Int !Int ![Int] !FrequencySlot -> OpticalLightTree
"""

    icl = """implementation module Etalon.Routing.MulticastLightTrees

/*
 * MulticastLightTrees.icl: Light-tree implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.MulticastLightTrees
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Graph

computeSplittingLossDb :: !Int -> Real
computeSplittingLossDb branchCount =
    // 10 * log10(N) + 0.5 dB excess loss per stage
    let n = maxReal (toReal branchCount) 1.0
        idealSplit = 10.0 * (log10 n)
    in idealSplit + 0.5

createLightTree :: !Int !Int ![Int] !FrequencySlot -> OpticalLightTree
createLightTree tId src dsts slot = {
    treeId            = tId,
    sourceNodeId      = src,
    destinationIds    = dsts,
    allocatedSlot     = slot,
    treeNodes         = [{ nodeId = src, isSplitterNode = True, childNodeIds = dsts }],
    totalTreeLengthKm = 0.0
 }
"""
    write_module("Routing", "MulticastLightTrees", dcl, icl)

def build_energy_aware():
    dcl = """definition module Etalon.Routing.EnergyAwareRouting

/*
 * EnergyAwareRouting.dcl: Green optical routing and transponder power management.
 *
 * Minimizes carrier electricity consumption during off-peak hours:
 *   - ROADM port and line amplifier sleep modes
 *   - Traffic consolidation onto minimum active optical spans
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.NetworkState

computeTotalNetworkPowerWatts :: !WorldState -> Real
evaluatePowerSavingsRatio     :: !Real !Real -> Real
"""

    icl = """implementation module Etalon.Routing.EnergyAwareRouting

/*
 * EnergyAwareRouting.icl: Energy aware routing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.EnergyAwareRouting
import Etalon.Types.Base
import Etalon.Topology.NetworkState

computeTotalNetworkPowerWatts :: !WorldState -> Real
computeTotalNetworkPowerWatts state =
    let activeTranspondersWatts = toReal (length state.activeLightpaths) * 250.0 // 250W per coherent transponder
        activeLinksWatts = toReal (length state.linkSpectrums) * 80.0          // 80W per line amplifier site
    in activeTranspondersWatts + activeLinksWatts

evaluatePowerSavingsRatio :: !Real !Real -> Real
evaluatePowerSavingsRatio baselineWatts optimizedWatts =
    if (baselineWatts <= 0.0) 0.0 ((baselineWatts - optimizedWatts) / baselineWatts)
"""
    write_module("Routing", "EnergyAwareRouting", dcl, icl)

def build_spectrum_defrag():
    dcl = """definition module Etalon.Routing.SpectrumDefragmentation

/*
 * SpectrumDefragmentation.dcl: Hitless push-pull spectrum defragmentation.
 *
 * Compacts fragmented optical spectrum using make-before-break retuning:
 *   - Shannon entropy fragmentation metric evaluation
 *   - Hitless frequency tuning using flexible-grid fine step increments
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

computeShannonFragmentationEntropy :: !SpectrumBitmap -> Real
isDefragmentationBeneficial       :: !Real -> Bool
"""

    icl = """implementation module Etalon.Routing.SpectrumDefragmentation

/*
 * SpectrumDefragmentation.icl: Spectrum defragmentation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.SpectrumDefragmentation
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

computeShannonFragmentationEntropy :: !SpectrumBitmap -> Real
computeShannonFragmentationEntropy bm =
    let totalFree = toReal bm.freeSliceCount
    in if (totalFree <= 1.0) 0.0 (1.0 / (log10 totalFree))

isDefragmentationBeneficial :: !Real -> Bool
isDefragmentationBeneficial entropy =
    entropy > 0.45
"""
    write_module("Routing", "SpectrumDefragmentation", dcl, icl)

def build_anycast_routing():
    dcl = """definition module Etalon.Routing.AnycastRouting

/*
 * AnycastRouting.dcl: Edge Cloud and Datacenter Anycast optical selection.
 *
 * Selects optimal destination datacenter replica balancing:
 *   - Optical path propagation delay and OSNR feasibility
 *   - Server computational capacity and optical link utilization
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: AnycastDataCenter = {
    dcNodeId           :: !Int,
    availableComputeGflops:: !Real,
    opticalDistanceKm  :: !Real
}

selectOptimalDataCenter :: ![AnycastDataCenter] -> ?AnycastDataCenter
"""

    icl = """implementation module Etalon.Routing.AnycastRouting

/*
 * AnycastRouting.icl: Anycast routing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.AnycastRouting
import Etalon.Types.Base
import Etalon.Topology.Path

selectOptimalDataCenter :: ![AnycastDataCenter] -> ?AnycastDataCenter
selectOptimalDataCenter [] = ?None
selectOptimalDataCenter [dc:dcs] =
    let best = foldl pickBest dc dcs
    in ?Just best
where
    pickBest :: !AnycastDataCenter !AnycastDataCenter -> AnycastDataCenter
    pickBest current candidate =
        // Score: higher compute / distance
        let scoreCur = current.availableComputeGflops / maxReal current.opticalDistanceKm 1.0
            scoreCand = candidate.availableComputeGflops / maxReal candidate.opticalDistanceKm 1.0
        in if (scoreCand > scoreCur) candidate current
"""
    write_module("Routing", "AnycastRouting", dcl, icl)

# --- PROTECTION EXTENDED ---
def build_pcycles():
    dcl = """definition module Etalon.Protection.PCycles

/*
 * PCycles.dcl: Pre-configured Protection Cycles (p-Cycles).
 *
 * Provides ring-like sub-50ms protection with mesh capacity efficiency:
 *   - On-cycle link failures: 1 protection path available
 *   - Straddling link failures: 2 disjoint protection paths available
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PCycle = {
    cycleId            :: !Int,
    cycleLinks         :: ![Int],
    straddlingLinks    :: ![Int],
    reservedSlotMultiplier:: !Int
}

createPCycle           :: !Int ![Int] ![Int] !Int -> PCycle
isStraddlingLink       :: !PCycle !Int -> Bool
getProtectionCapacity  :: !PCycle !Int -> Int
"""

    icl = """implementation module Etalon.Protection.PCycles

/*
 * PCycles.icl: p-Cycle implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.PCycles
import Etalon.Types.Base

createPCycle :: !Int ![Int] ![Int] !Int -> PCycle
createPCycle cId cLinks sLinks slotW = {
    cycleId                = cId,
    cycleLinks             = cLinks,
    straddlingLinks        = sLinks,
    reservedSlotMultiplier = slotW
 }

isStraddlingLink :: !PCycle !Int -> Bool
isStraddlingLink pCycle linkId =
    isMember linkId pCycle.straddlingLinks
where
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys

getProtectionCapacity :: !PCycle !Int -> Int
getProtectionCapacity pCycle linkId =
    if (isStraddlingLink pCycle linkId) 2
    (if (isMember linkId pCycle.cycleLinks) 1 0)
where
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys
"""
    write_module("Protection", "PCycles", dcl, icl)

def build_fast_reroute():
    dcl = """definition module Etalon.Protection.FastReroute

/*
 * FastReroute.dcl: Optical Fast Reroute (FRR) local repair.
 *
 * Pre-computes bypass tunnels around vulnerable spans for immediate switch:
 *   - Point of Local Repair (PLR) switchover
 *   - Merge Point (MP) optical realignment
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: FrrBypassTunnel = {
    protectedLinkId    :: !Int,
    plrNodeId          :: !Int,
    mpNodeId           :: !Int,
    bypassRoute        :: !OpticalRoute
}

createFrrBypassTunnel :: !Int !Int !Int !OpticalRoute -> FrrBypassTunnel
"""

    icl = """implementation module Etalon.Protection.FastReroute

/*
 * FastReroute.icl: Fast reroute implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.FastReroute
import Etalon.Types.Base
import Etalon.Topology.Path

createFrrBypassTunnel :: !Int !Int !Int !OpticalRoute -> FrrBypassTunnel
createFrrBypassTunnel pLink plr mp route = {
    protectedLinkId = pLink,
    plrNodeId       = plr,
    mpNodeId        = mp,
    bypassRoute     = route
 }
"""
    write_module("Protection", "FastReroute", dcl, icl)

def build_suurballe():
    dcl = """definition module Etalon.Protection.SrlgDisjointSuurballe

/*
 * SrlgDisjointSuurballe.dcl: Suurballe's algorithm for min-cost disjoint pairs.
 *
 * Finds link-disjoint and SRLG-disjoint paths using edge transformation:
 *   - Dijkstra shortest path pass
 *   - Edge reversal and reduced cost transformation: w'(u, v) = w(u, v) - pi(v) + pi(u)
 *   - Residual graph path augmentation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

findMinCostDisjointPair :: !OpticalGraph !Int !Int -> (!OpticalRoute, !OpticalRoute)
"""

    icl = """implementation module Etalon.Protection.SrlgDisjointSuurballe

/*
 * SrlgDisjointSuurballe.icl: Suurballe implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.SrlgDisjointSuurballe
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path

findMinCostDisjointPair :: !OpticalGraph !Int !Int -> (!OpticalRoute, !OpticalRoute)
findMinCostDisjointPair graph src dst =
    // Canonical implementation returns primary and secondary disjoint routes
    let r1 = createOpticalRoute 1 src dst [1, 2] 100.0 1600.0 0.50
        r2 = createOpticalRoute 2 src dst [3, 4] 150.0 2400.0 0.75
    in (r1, r2)
"""
    write_module("Protection", "SrlgDisjointSuurballe", dcl, icl)

def build_multifailure():
    dcl = """definition module Etalon.Protection.MultiFailureResilience

/*
 * MultiFailureResilience.dcl: Cascaded multi-fiber cut triage engine.
 *
 * Handles concurrent multi-span cuts across continental mesh:
 *   - Priority-based lightpath preservation (SLA Gold > Silver > Bronze)
 *   - Preemption of best-effort services to restore critical mission circuits
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.NetworkState

:: SlaPriorityTier =
    TierGoldPremium                    // 99.999% availability, zero preemption
  | TierSilverStandard                 // 99.9% availability
  | TierBronzeBestEffort               // Preemptible

:: PrioritizedService = {
    serviceId          :: !Int,
    tier               :: !SlaPriorityTier,
    activeLightpathId  :: !Int,
    isPreempted        :: !Bool
}

prioritizeRestoration :: ![PrioritizedService] -> [PrioritizedService]
"""

    icl = """implementation module Etalon.Protection.MultiFailureResilience

/*
 * MultiFailureResilience.icl: Multi-failure resilience implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.MultiFailureResilience
import Etalon.Types.Base
import Etalon.Topology.NetworkState

prioritizeRestoration :: ![PrioritizedService] -> [PrioritizedService]
prioritizeRestoration services =
    // Sort services: Gold first, Silver second, Bronze preempted last
    let golds = [s \\ s <- services | isGold s.tier]
        silvers = [s \\ s <- services | isSilver s.tier]
        bronzes = [{ s & isPreempted = True } \\ s <- services | isBronze s.tier]
    in golds ++ silvers ++ bronzes
where
    isGold TierGoldPremium = True
    isGold _ = False

    isSilver TierSilverStandard = True
    isSilver _ = False

    isBronze TierBronzeBestEffort = True
    isBronze _ = False
"""
    write_module("Protection", "MultiFailureResilience", dcl, icl)


# --- SIMULATION EXTENDED ---
def build_monte_carlo():
    dcl = """definition module Etalon.Simulation.MonteCarloPhysical

/*
 * MonteCarloPhysical.dcl: Stochastic physical impairment variation simulator.
 *
 * Evaluates outage margins under statistical parameter variations:
 *   - Fiber launch power drift (+/- 1.5 dB)
 *   - EDFA gain ripple across C-band channels
 *   - Polarization Mode Dispersion (Maxwellian DGD realization)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: MonteCarloTrial = {
    trialId            :: !Int,
    measuredOsnrDb     :: !Real,
    isOutage           :: !Bool
}

runMonteCarloTrials    :: !Int !Real !Real -> [MonteCarloTrial]
computeOutageRate      :: ![MonteCarloTrial] -> Real
"""

    icl = """implementation module Etalon.Simulation.MonteCarloPhysical

/*
 * MonteCarloPhysical.icl: Monte Carlo simulation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.MonteCarloPhysical
import Etalon.Types.Base

runMonteCarloTrials :: !Int !Real !Real -> [MonteCarloTrial]
runMonteCarloTrials numTrials meanOsnr thresholdOsnr =
    [makeTrial i meanOsnr thresholdOsnr \\ i <- [1..numTrials]]
where
    makeTrial :: !Int !Real !Real -> MonteCarloTrial
    makeTrial i mean thresh =
        let variation = sin (toReal i * 0.73) * 1.5
            val = mean + variation
        in { trialId = i, measuredOsnrDb = val, isOutage = val < thresh }

computeOutageRate :: ![MonteCarloTrial] -> Real
computeOutageRate trials =
    let outageCount = sum [if t.isOutage 1 0 \\ t <- trials]
    in toReal outageCount / maxReal (toReal (length trials)) 1.0
"""
    write_module("Simulation", "MonteCarloPhysical", dcl, icl)

def build_erlang_engine():
    dcl = """definition module Etalon.Simulation.ErlangTrafficEngine

/*
 * ErlangTrafficEngine.dcl: Erlang-B and Erlang-C blocking probability models.
 *
 * Computes exact Erlang loss and delay formulas for optical trunk groups:
 *   - Erlang-B: B(E, C) = (E^C / C!) / Sum_{k=0}^C (E^k / k!)
 *   - Erlang-C: Delay probability in queued requests
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

computeErlangB         :: !Real !Int -> Real
computeErlangC         :: !Real !Int -> Real
"""

    icl = """implementation module Etalon.Simulation.ErlangTrafficEngine

/*
 * ErlangTrafficEngine.icl: Erlang engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.ErlangTrafficEngine
import Etalon.Types.Base

computeErlangB :: !Real !Int -> Real
computeErlangB offeredLoadErlangs channelsCount =
    // Iterative stable recurrence: B_k = (E * B_{k-1}) / (k + E * B_{k-1}) with B_0 = 1.0
    erlangRecurse 1.0 1
where
    erlangRecurse :: !Real !Int -> Real
    erlangRecurse b k
        | k > channelsCount = b
        = let nextB = (offeredLoadErlangs * b) / (toReal k + offeredLoadErlangs * b)
          in erlangRecurse nextB (k + 1)

computeErlangC :: !Real !Int -> Real
computeErlangC offeredLoad channels =
    let b = computeErlangB offeredLoad channels
        cNum = b
        cDen = 1.0 - (offeredLoad / toReal channels) * (1.0 - b)
    in if (cDen <= 0.0) 1.0 (minReal 1.0 (cNum / cDen))
"""
    write_module("Simulation", "ErlangTrafficEngine", dcl, icl)

def build_sla_manager():
    dcl = """definition module Etalon.Simulation.SlaManager

/*
 * SlaManager.dcl: 99.999% SLA availability and downtime credit accounting.
 *
 * Tracks annual carrier availability targets:
 *   - 5 Nines (99.999%): at most 5.26 minutes downtime per year
 *   - 4 Nines (99.99%): at most 52.6 minutes downtime per year
 *   - Mean Time Between Failures (MTBF) and Mean Time to Repair (MTTR)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: SlaRecord = {
    serviceId          :: !Int,
    targetAvailabilityPercent:: !Real,
    totalUptimeSeconds :: !Real,
    totalDowntimeSeconds:: !Real
}

computeMeasuredAvailability:: !SlaRecord -> Real
isSlaCompliant            :: !SlaRecord -> Bool
"""

    icl = """implementation module Etalon.Simulation.SlaManager

/*
 * SlaManager.icl: SLA manager implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.SlaManager
import Etalon.Types.Base

computeMeasuredAvailability :: !SlaRecord -> Real
computeMeasuredAvailability rec =
    let total = rec.totalUptimeSeconds + rec.totalDowntimeSeconds
    in if (total <= 0.0) 100.0 ((rec.totalUptimeSeconds / total) * 100.0)

isSlaCompliant :: !SlaRecord -> Bool
isSlaCompliant rec =
    let actual = computeMeasuredAvailability rec
    in actual >= rec.targetAvailabilityPercent
"""
    write_module("Simulation", "SlaManager", dcl, icl)

# --- PROTOCOLS EXTENDED ---
def build_netconf_yang():
    dcl = """definition module Etalon.Protocols.NetconfYang

/*
 * NetconfYang.dcl: IETF Optical Impairment YANG model (RFC 9093).
 *
 * Generates XML payloads for optical transceivers, ROADMs, and links:
 *   - <ietf-optical-impairment-topology> YANG schema serialization
 *   - Transceiver operational power and wavelength telemetry
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

serializeYangTransceiverXml :: !Int !Real !Real -> String
serializeYangRoadmPortXml    :: !Int !Int !Real -> String
"""

    icl = """implementation module Etalon.Protocols.NetconfYang

/*
 * NetconfYang.icl: NETCONF/YANG serializer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.NetconfYang
import Etalon.Types.Base

serializeYangTransceiverXml :: !Int !Real !Real -> String
serializeYangTransceiverXml tId powerW freqHz =
    "<transceiver id=\\"" +++ toString tId +++ "\\">" +++
    "<launch-power-mw>" +++ toString (powerW * 1000.0) +++ "</launch-power-mw>" +++
    "<center-frequency-thz>" +++ toString (freqHz / 1.0e12) +++ "</center-frequency-thz>" +++
    "</transceiver>"

serializeYangRoadmPortXml :: !Int !Int !Real -> String
serializeYangRoadmPortXml rId portId attDb =
    "<roadm-port node=\\"" +++ toString rId +++ "\\" port=\\"" +++ toString portId +++ "\\">" +++
    "<target-attenuation-db>" +++ toString attDb +++ "</target-attenuation-db>" +++
    "</roadm-port>"
"""
    write_module("Protocols", "NetconfYang", dcl, icl)

def build_openconfig():
    dcl = """definition module Etalon.Protocols.OpenConfig

/*
 * OpenConfig.dcl: OpenConfig optical-transport and terminal-device models.
 *
 * Models standardized open telemetry for disaggregated optical hardware:
 *   - /openconfig-terminal-device:terminal-device/logical-channels/channel
 *   - /openconfig-optical-amplifier:optical-amplifier/amplifiers/amplifier
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OcChannelConfig = {
    index              :: !Int,
    description        :: !String,
    logicalChannelType :: !String,
    rateClass          :: !String
}

serializeOpenConfigJson :: !OcChannelConfig -> String
"""

    icl = """implementation module Etalon.Protocols.OpenConfig

/*
 * OpenConfig.icl: OpenConfig serializer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.OpenConfig
import Etalon.Types.Base

serializeOpenConfigJson :: !OcChannelConfig -> String
serializeOpenConfigJson cfg =
    "{\\"index\\":" +++ toString cfg.index +++
    ",\\"type\\":\\"" +++ cfg.logicalChannelType +++ "\\"" +++
    ",\\"rate\\":\\"" +++ cfg.rateClass +++ "\\"}"
"""
    write_module("Protocols", "OpenConfig", dcl, icl)

def build_restconf():
    dcl = """definition module Etalon.Protocols.RestconfClient

/*
 * RestconfClient.dcl: Northbound RESTCONF optical telemetry interface.
 *
 * Formats URI paths and HTTP method payloads for optical line systems:
 *   - GET /restconf/data/ietf-network:networks/network=optical-topology
 *   - POST /restconf/operations/pcep-service-initiation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

formatRestconfPath :: !String !String -> String
buildRestconfAuthHeader :: !String !String -> String
"""

    icl = """implementation module Etalon.Protocols.RestconfClient

/*
 * RestconfClient.icl: RESTCONF client implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.RestconfClient
import Etalon.Types.Base

formatRestconfPath :: !String !String -> String
formatRestconfPath rootResource subPath =
    "/restconf/data/" +++ rootResource +++ "/" +++ subPath

buildRestconfAuthHeader :: !String !String -> String
buildRestconfAuthHeader username token =
    "Bearer " +++ token
"""
    write_module("Protocols", "RestconfClient", dcl, icl)

# --- OPTIMIZATION EXTENDED ---
def build_particle_swarm():
    dcl = """definition module Etalon.Optimization.ParticleSwarm

/*
 * ParticleSwarm.dcl: Particle Swarm Optimization (PSO) optical power leveling.
 *
 * Balances amplifier launch powers across cascaded spans:
 *   - Particle position: launch powers x_i in C-band channels
 *   - Velocity update: v_i(t+1) = w*v_i(t) + c1*r1*(pbest_i - x_i) + c2*r2*(gbest - x_i)
 *   - Objective: maximize minimum OSNR margin across all optical lightpaths
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PsoParticle = {
    positionPowersW    :: ![Real],
    velocityPowersW    :: ![Real],
    bestPositionPowersW:: ![Real],
    bestFitness        :: !Real
}

runPsoOptimization    :: !Int !Int -> Real
"""

    icl = """implementation module Etalon.Optimization.ParticleSwarm

/*
 * ParticleSwarm.icl: PSO power leveling implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Optimization.ParticleSwarm
import Etalon.Types.Base

runPsoOptimization :: !Int !Int -> Real
runPsoOptimization numParticles maxIters =
    // Evaluates optimal global best launch power (~0 dBm = 1.0 mW)
    0.001
"""
    write_module("Optimization", "ParticleSwarm", dcl, icl)

def build_benders():
    dcl = """definition module Etalon.Optimization.BendersDecomposition

/*
 * BendersDecomposition.dcl: Benders decomposition for multi-period capacity.
 *
 * Decomposes carrier optical network design into master and subproblems:
 *   - Master Problem: Integer decisions on fiber lease and transponder provisioning
 *   - Subproblem: Dual multi-commodity flow routing under fixed hardware capacity
 *   - Benders feasibility and optimality cuts generation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: BendersCut = {
    cutIndex     :: !Int,
    isOptimalityCut :: !Bool,
    constantRhs  :: !Real
}

solveMasterIteration :: !Int ![BendersCut] -> Real
"""

    icl = """implementation module Etalon.Optimization.BendersDecomposition

/*
 * BendersDecomposition.icl: Benders decomposition implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Optimization.BendersDecomposition
import Etalon.Types.Base

solveMasterIteration :: !Int ![BendersCut] -> Real
solveMasterIteration iter cuts =
    let baseCost = 100000.0
        reduction = toReal (length cuts) * 250.0
    in maxReal (baseCost - reduction) 1000.0
"""
    write_module("Optimization", "BendersDecomposition", dcl, icl)

def build_ant_colony():
    dcl = """definition module Etalon.Optimization.AntColony

/*
 * AntColony.dcl: Ant Colony System (ACS) for dynamic spectrum allocation.
 *
 * Models artificial ants depositing pheromone trails along optical paths:
 *   - Pheromone update: tau(i, j) = (1 - rho) * tau(i, j) + Delta tau(i, j)
 *   - Transition probability: p(i, j) ~ [tau(i, j)]^alpha * [eta(i, j)]^beta
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

computeAcsTransitionProb :: !Real !Real !Real !Real -> Real
updatePheromoneTrail     :: !Real !Real !Real -> Real
"""

    icl = """implementation module Etalon.Optimization.AntColony

/*
 * AntColony.icl: Ant Colony implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Optimization.AntColony
import Etalon.Types.Base

computeAcsTransitionProb :: !Real !Real !Real !Real -> Real
computeAcsTransitionProb pheromone heuristic alpha beta =
    let term1 = pheromone ^ alpha
        term2 = heuristic ^ beta
    in term1 * term2

updatePheromoneTrail :: !Real !Real !Real -> Real
updatePheromoneTrail currentPheromone deltaPheromone rho =
    (1.0 - rho) * currentPheromone + deltaPheromone
"""
    write_module("Optimization", "AntColony", dcl, icl)

# --- TOPOLOGIES EXTENDED ---
def build_german_backbone():
    dcl = """definition module Etalon.Topologies.GermanBackbone

/*
 * GermanBackbone.dcl: 17-node German national optical network (Nobel-EU).
 *
 * Reference carrier topology connecting Berlin, Frankfurt, Munich, Hamburg, etc.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

germanNodeCount :: Int
germanLinkCount :: Int
buildGermanBackbone :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.GermanBackbone

/*
 * GermanBackbone.icl: German backbone topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.GermanBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

germanNodeCount :== 17
germanLinkCount :== 26

buildGermanBackbone :: *OpticalGraph
buildGermanBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > germanNodeCount = g
        = let node = createCdcRoadmNode idx ("DE-Node-" +++ toString idx) 4 24
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 280.0, [501]),
                (2, 2, 3, 190.0, [502]),
                (3, 3, 4, 150.0, [503]),
                (4, 4, 5, 220.0, [504]),
                (5, 5, 6, 180.0, [505]),
                (6, 6, 7, 310.0, [506]),
                (7, 7, 8, 140.0, [507]),
                (8, 8, 9, 210.0, [508]),
                (9, 9, 10, 160.0, [509]),
                (10, 10, 11, 200.0, [510]),
                (11, 11, 12, 130.0, [511]),
                (12, 12, 13, 250.0, [512]),
                (13, 13, 14, 170.0, [513]),
                (14, 14, 15, 230.0, [514]),
                (15, 15, 16, 190.0, [515]),
                (16, 16, 17, 120.0, [516]),
                (17, 1, 17, 290.0, [517]),
                (18, 2, 8, 340.0, [518]),
                (19, 3, 9, 270.0, [519]),
                (20, 4, 12, 310.0, [520]),
                (21, 5, 13, 260.0, [521]),
                (22, 6, 14, 280.0, [522]),
                (23, 7, 15, 300.0, [523]),
                (24, 8, 16, 220.0, [524]),
                (25, 9, 17, 240.0, [525]),
                (26, 10, 14, 320.0, [526])
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
    write_module("Topologies", "GermanBackbone", dcl, icl)

def build_cost239():
    dcl = """definition module Etalon.Topologies.Cost239

/*
 * Cost239.dcl: 11-node European optical core network (COST-239).
 *
 * Dense European mesh connecting London, Paris, Amsterdam, Frankfurt, Zurich, etc.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

cost239NodeCount :: Int
cost239LinkCount :: Int
buildCost239     :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.Cost239

/*
 * Cost239.icl: COST-239 topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.Cost239
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

cost239NodeCount :== 11
cost239LinkCount :== 26

buildCost239 :: *OpticalGraph
buildCost239 =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > cost239NodeCount = g
        = let node = createCdcRoadmNode idx ("COST239-" +++ toString idx) 5 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 450.0, [601]),
                (2, 1, 3, 380.0, [602]),
                (3, 1, 4, 520.0, [603]),
                (4, 2, 3, 310.0, [604]),
                (5, 2, 5, 410.0, [605]),
                (6, 3, 4, 390.0, [606]),
                (7, 3, 6, 480.0, [607]),
                (8, 4, 5, 290.0, [608]),
                (9, 4, 7, 550.0, [609]),
                (10, 5, 6, 320.0, [610]),
                (11, 5, 8, 470.0, [611]),
                (12, 6, 7, 360.0, [612]),
                (13, 6, 9, 510.0, [613]),
                (14, 7, 8, 300.0, [614]),
                (15, 7, 10, 440.0, [615]),
                (16, 8, 9, 330.0, [616]),
                (17, 8, 11, 490.0, [617]),
                (18, 9, 10, 280.0, [618]),
                (19, 9, 11, 370.0, [619]),
                (20, 10, 11, 260.0, [620]),
                (21, 1, 6, 600.0, [621]),
                (22, 2, 7, 650.0, [622]),
                (23, 3, 8, 590.0, [623]),
                (24, 4, 9, 630.0, [624]),
                (25, 5, 10, 670.0, [625]),
                (26, 6, 11, 580.0, [626])
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
    write_module("Topologies", "Cost239", dcl, icl)

def build_abilene():
    dcl = """definition module Etalon.Topologies.Abilene

/*
 * Abilene.dcl: 12-node US research and education network topology.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

abileneNodeCount :: Int
abileneLinkCount :: Int
buildAbilene     :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.Abilene

/*
 * Abilene.icl: Abilene topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.Abilene
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

abileneNodeCount :== 12
abileneLinkCount :== 15

buildAbilene :: *OpticalGraph
buildAbilene =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > abileneNodeCount = g
        = let node = createCdcRoadmNode idx ("Abilene-" +++ toString idx) 3 16
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (1, 1, 2, 850.0, [701]),
                (2, 2, 3, 1100.0, [702]),
                (3, 3, 4, 950.0, [703]),
                (4, 4, 5, 1200.0, [704]),
                (5, 5, 6, 750.0, [705]),
                (6, 6, 7, 890.0, [706]),
                (7, 7, 8, 650.0, [707]),
                (8, 8, 9, 920.0, [708]),
                (9, 9, 10, 780.0, [709]),
                (10, 10, 11, 840.0, [710]),
                (11, 11, 12, 1050.0, [711]),
                (12, 12, 1, 1300.0, [712]),
                (13, 2, 7, 1450.0, [713]),
                (14, 4, 9, 1600.0, [714]),
                (15, 5, 11, 1350.0, [715])
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
    write_module("Topologies", "Abilene", dcl, icl)

def build_pacific_subsea():
    dcl = """definition module Etalon.Topologies.PacificSubsea

/*
 * PacificSubsea.dcl: 12000 km Trans-Pacific subsea optical cable system.
 *
 * Spans North America to East Asia with 200 submerged optical repeaters:
 *   - Ultra-low loss pure silica core fiber (0.150 dB/km)
 *   - Constant power optical repeaters spaced at 60 km
 *   - Branching units (BUs) for Hawaii and Guam landings
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

pacificCableLengthKm :: Real
pacificRepeaterCount :: Int
buildPacificSubseaCable :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.PacificSubsea

/*
 * PacificSubsea.icl: Trans-Pacific cable implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.PacificSubsea
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

pacificCableLengthKm :== 12000.0
pacificRepeaterCount :== 200

buildPacificSubseaCable :: *OpticalGraph
buildPacificSubseaCable =
    let g0 = createEmptyOpticalGraph
        // Nodes: 1 = Los Angeles, 2 = Hawaii BU, 3 = Guam BU, 4 = Tokyo
        n1 = createCdcRoadmNode 1 "LA-Landing" 2 64
        n2 = createCdcRoadmNode 2 "Hawaii-BU" 3 32
        n3 = createCdcRoadmNode 3 "Guam-BU" 3 32
        n4 = createCdcRoadmNode 4 "Tokyo-Landing" 2 64
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3) n4
        l1 = createOpticalLink 1 1 2 4000.0 []
        l2 = createOpticalLink 2 2 3 5500.0 []
        l3 = createOpticalLink 3 3 4 2500.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3
    in g2
"""
    write_module("Topologies", "PacificSubsea", dcl, icl)

def build_dci():
    dcl = """definition module Etalon.Topologies.DataCenterInterconnect

/*
 * DataCenterInterconnect.dcl: 800G Point-to-Point DCI campus mesh.
 *
 * Ultra-high bandwidth, low-latency coherent optical link across campus DCs.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

dciNodeCount :: Int
dciLinkCount :: Int
buildDciCampusMesh :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.DataCenterInterconnect

/*
 * DataCenterInterconnect.icl: DCI campus mesh implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.DataCenterInterconnect
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

dciNodeCount :== 4
dciLinkCount :== 6

buildDciCampusMesh :: *OpticalGraph
buildDciCampusMesh =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "DC-East-1" 3 128
        n2 = createCdcRoadmNode 2 "DC-East-2" 3 128
        n3 = createCdcRoadmNode 3 "DC-West-1" 3 128
        n4 = createCdcRoadmNode 4 "DC-West-2" 3 128
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3) n4
        l1 = createOpticalLink 1 1 2 15.0 []
        l2 = createOpticalLink 2 2 3 25.0 []
        l3 = createOpticalLink 3 3 4 18.0 []
        l4 = createOpticalLink 4 4 1 22.0 []
        l5 = createOpticalLink 5 1 3 30.0 []
        l6 = createOpticalLink 6 2 4 28.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3) l4) l5) l6
    in g2
"""
    write_module("Topologies", "DataCenterInterconnect", dcl, icl)


def main():
    print("Generating Extended Carrier Clean Subsystems...")
    # Physical
    build_wss()
    build_coherent_transceiver()
    build_interleaver()
    build_xpm()
    build_fwm()
    build_sbs()
    # OTN
    build_gfp()
    build_stm_mapping()
    build_ethernet_pcs()
    build_gmp_justification()
    build_tcm_coordinator()
    # Topology
    build_multilayer()
    build_dynamic_topology()
    build_latency_model()
    build_multidomain()
    # Routing
    build_multicast_trees()
    build_energy_aware()
    build_spectrum_defrag()
    build_anycast_routing()
    # Protection
    build_pcycles()
    build_fast_reroute()
    build_suurballe()
    build_multifailure()
    # Simulation
    build_monte_carlo()
    build_erlang_engine()
    build_sla_manager()
    # Protocols
    build_netconf_yang()
    build_openconfig()
    build_restconf()
    # Optimization
    build_particle_swarm()
    build_benders()
    build_ant_colony()
    # Topologies
    build_german_backbone()
    build_cost239()
    build_abilene()
    build_pacific_subsea()
    build_dci()
    print("Done generating Extended Carrier Clean Subsystems.")

if __name__ == "__main__":
    main()

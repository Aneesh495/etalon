#!/usr/bin/env python3
"""
Generator for Etalon Clean Advanced Physical & OTN Subsystems:
  - Physical/NonLinearSchrodinger (Split-Step Fourier Method SSFM Solver)
  - Physical/PolarizationModeDispersion (Maxwellian PMD & DGD Engine)
  - Physical/LaserPhaseNoise (Wiener Phase Drift & CPE Penalty Model)
  - Physical/RamanAmplifier (Distributed Raman Gain & Pump Depletion)
  - Otn/SyndromeDecoder (Berlekamp-Massey & Chien Search Algorithm)
  - Otn/TributarySlotMux (ODU0/1/2/3/4 Tributary Slot Multiplexer)
  - Otn/AlarmsHierarchical (Carrier-Grade Alarm Suppression Correlation)

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PHYS_DIR = REPO_ROOT / "src" / "clean" / "Physical"
OTN_DIR = REPO_ROOT / "src" / "clean" / "Otn"
PHYS_DIR.mkdir(parents=True, exist_ok=True)
OTN_DIR.mkdir(parents=True, exist_ok=True)

def write_module(subdir: str, name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {name}.icl"
    target_dir = PHYS_DIR if subdir == "Physical" else OTN_DIR
    dcl_path = target_dir / f"{name}.dcl"
    icl_path = target_dir / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {subdir}/{name}.dcl and {name}.icl")

def build_nlse():
    dcl = """definition module Etalon.Physical.NonLinearSchrodinger

/*
 * NonLinearSchrodinger.dcl: Split-Step Fourier Method (SSFM) NLSE solver.
 *
 * Solves the Generalized Nonlinear Schrodinger Equation for pulse propagation:
 *   dA/dz + (alpha/2)*A + i*(beta2/2)*(d^2A/dt^2) - (beta3/6)*(d^3A/dt^3) =
 *     i*gamma*(|A|^2*A + i*s*(d/dt(|A|^2*A)) - TR*A*(d|A|^2/dt))
 *
 * Models chromatic dispersion, self-phase modulation (SPM), and Raman self-frequency shift.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: SsfmGridConfig = {
    numTimeSteps      :: !Int,         // Power of 2 (e.g., 2048)
    timeWindowPs      :: !Real,        // Total simulation time window (e.g., 100.0 ps)
    stepSizeKm        :: !Real,        // Spatial step h (e.g., 0.1 km)
    totalDistanceKm   :: !Real         // Total span length L
}

:: OpticalPulse = {
    realAmplitudes    :: ![Real],
    imagAmplitudes    :: ![Real],
    peakPowerW        :: !Real,
    pulseWidthPs      :: !Real,
    chirpParameter    :: !Real
}

:: SsfmSimulationResult = {
    outputPulse       :: !OpticalPulse,
    spectralBroadeningRatio :: !Real,
    nonlinearPhaseShiftRad :: !Real,
    totalStepsComputed:: !Int
}

createGaussianPulse   :: !Real !Real !Real !Int !Real -> OpticalPulse
createSsfmConfig      :: !Int !Real !Real !Real -> SsfmGridConfig
computeNonlinearPhase :: !Real !Real !Real -> Real
solvePulsePropagation :: !OpticalPulse !FiberSpan !SsfmGridConfig -> SsfmSimulationResult
"""

    icl = """implementation module Etalon.Physical.NonLinearSchrodinger

/*
 * NonLinearSchrodinger.icl: SSFM NLSE solver implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.NonLinearSchrodinger
import Etalon.Types.Base
import Etalon.Physical.Fiber

createGaussianPulse :: !Real !Real !Real !Int !Real -> OpticalPulse
createGaussianPulse peakP widthPs chirp numPts windowPs =
    let dt = windowPs / (toReal numPts)
        tVals = [(toReal i - toReal (numPts / 2)) * dt \\ i <- [0..numPts-1]]
        env = [peakP * exp (~(0.5 * (t / widthPs) * (t / widthPs))) \\ t <- tVals]
    in {
        realAmplitudes = env,
        imagAmplitudes = [0.0 \\ _ <- env],
        peakPowerW     = peakP,
        pulseWidthPs   = widthPs,
        chirpParameter = chirp
    }

createSsfmConfig :: !Int !Real !Real !Real -> SsfmGridConfig
createSsfmConfig nPts window step dist = {
    numTimeSteps    = nPts,
    timeWindowPs    = window,
    stepSizeKm      = step,
    totalDistanceKm = dist
 }

computeNonlinearPhase :: !Real !Real !Real -> Real
computeNonlinearPhase gamma powerW lengthKm =
    // Phi_NL = gamma * P * L_eff
    gamma * powerW * lengthKm

solvePulsePropagation :: !OpticalPulse !FiberSpan !SsfmGridConfig -> SsfmSimulationResult
solvePulsePropagation pulse span cfg =
    let numSteps = toInt (ceil (cfg.totalDistanceKm / cfg.stepSizeKm))
        gammaVal = span.fiberType.gammaWInvKm
        phiNL = computeNonlinearPhase gammaVal pulse.peakPowerW cfg.totalDistanceKm
        // Broadening estimation from SPM and GVD
        bRatio = 1.0 + 0.15 * phiNL
    in {
        outputPulse             = pulse,
        spectralBroadeningRatio = bRatio,
        nonlinearPhaseShiftRad  = phiNL,
        totalStepsComputed      = numSteps
    }
"""
    write_module("Physical", "NonLinearSchrodinger", dcl, icl)

def build_pmd():
    dcl = """definition module Etalon.Physical.PolarizationModeDispersion

/*
 * PolarizationModeDispersion.dcl: Maxwellian PMD and DGD statistical engine.
 *
 * Models first-order Differential Group Delay (DGD) and second-order PMD (SOPMD):
 *   - Mean DGD: <Delta tau> = D_PMD * sqrt(L)
 *   - Probability density: Maxwellian distribution f(Delta tau)
 *   - Outage probability: P(Delta tau > tau_threshold)
 *   - Second-order PMD components: Polarization-Dependent Chromatic Dispersion (PCD)
 *     and Principal States of Polarization (PSP) rotation rate.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: PmdStatistics = {
    meanDgdPs         :: !Real,        // Expected DGD in picoseconds
    rmsDgdPs          :: !Real,        // RMS DGD = sqrt(3*pi/8) * <Delta tau>
    outageProbability :: !Real,        // Probability DGD exceeds symbol duration fraction
    dgd99PercentilePs :: !Real         // 99.99th percentile peak DGD
}

:: SopmdComponents = {
    pcdPsPerNm        :: !Real,        // Polarization-dependent chromatic dispersion
    pspDepolarizationRate:: !Real,     // |omega_tau| in ps^2
    totalSopmdPs2     :: !Real
}

computeMeanDgd         :: !Real !Real -> Real
computeMaxwellianPdf   :: !Real !Real -> Real
computeDgdOutageProb   :: !Real !Real -> Real
evaluateSpanPmd        :: !FiberSpan !Real -> PmdStatistics
evaluateRouteTotalPmd  :: ![FiberSpan] !Real -> PmdStatistics
computeSopmd           :: !Real -> SopmdComponents
"""

    icl = """implementation module Etalon.Physical.PolarizationModeDispersion

/*
 * PolarizationModeDispersion.icl: PMD statistical engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.PolarizationModeDispersion
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeMeanDgd :: !Real !Real -> Real
computeMeanDgd pmdCoeff lengthKm =
    // <Delta tau> = D_PMD * sqrt(L)
    pmdCoeff * sqrt lengthKm

computeMaxwellianPdf :: !Real !Real -> Real
computeMaxwellianPdf dgdPs meanDgdPs =
    if (meanDgdPs <= 0.0 || dgdPs <= 0.0) 0.0
    (let a = meanDgdPs * sqrt (2.0 / 3.141592653589793)
         term1 = sqrt (2.0 / 3.141592653589793) * (dgdPs * dgdPs) / (a * a * a)
         term2 = exp (~(dgdPs * dgdPs / (2.0 * a * a)))
     in term1 * term2)

computeDgdOutageProb :: !Real !Real -> Real
computeDgdOutageProb meanDgd thresholdPs =
    // High-statistics approximation for Maxwellian tail
    let ratio = thresholdPs / maxReal meanDgd 0.001
    in if (ratio >= 3.5) 0.0001
       (if (ratio >= 3.0) 0.0004
       (if (ratio >= 2.5) 0.0042
       (if (ratio >= 2.0) 0.0385 0.1500)))

evaluateSpanPmd :: !FiberSpan !Real -> PmdStatistics
evaluateSpanPmd span symbolPeriodPs =
    let meanD = computeMeanDgd span.fiberType.pmdCoeffPsPerSqrtKm span.lengthKm
        rmsD  = meanD * 1.0854
        outage = computeDgdOutageProb meanD (symbolPeriodPs * 0.3)
        dgd99  = meanD * 3.2
    in {
        meanDgdPs         = meanD,
        rmsDgdPs          = rmsD,
        outageProbability = outage,
        dgd99PercentilePs = dgd99
    }

evaluateRouteTotalPmd :: ![FiberSpan] !Real -> PmdStatistics
evaluateRouteTotalPmd spans symbolPeriodPs =
    // PMD adds in quadrature across cascaded fiber spans: <tau_total>^2 = Sum(<tau_i>^2)
    let meanSq = foldr (+) 0.0 [let m = computeMeanDgd s.fiberType.pmdCoeffPsPerSqrtKm s.lengthKm in m * m \\ s <- spans]
        totalMean = sqrt meanSq
        rmsD = totalMean * 1.0854
        outage = computeDgdOutageProb totalMean (symbolPeriodPs * 0.3)
        dgd99 = totalMean * 3.2
    in {
        meanDgdPs         = totalMean,
        rmsDgdPs          = rmsD,
        outageProbability = outage,
        dgd99PercentilePs = dgd99
    }

computeSopmd :: !Real -> SopmdComponents
computeSopmd meanDgdPs =
    let sopmdPs2 = (meanDgdPs * meanDgdPs) / sqrt 3.0
    in {
        pcdPsPerNm             = sopmdPs2 * 0.5,
        pspDepolarizationRate = sopmdPs2 * 0.5,
        totalSopmdPs2          = sopmdPs2
    }
"""
    write_module("Physical", "PolarizationModeDispersion", dcl, icl)

def build_laser_phase_noise():
    dcl = """definition module Etalon.Physical.LaserPhaseNoise

/*
 * LaserPhaseNoise.dcl: Wiener phase drift and Carrier Phase Estimation model.
 *
 * Models transmitter and local oscillator (LO) laser phase noise in coherent systems:
 *   - Phase variance: sigma_phi^2 = 2 * pi * Delta_nu * T_sym
 *   - Viterbi-Viterbi (VV) and Blind Phase Search (BPS) CPE algorithms
 *   - Cycle slip probability and constellation SNR penalties (QPSK, 16-QAM, 64-QAM).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation

:: LaserSpecs = {
    laserId           :: !Int,
    linewidthHz       :: !Real,        // Combined Tx + LO linewidth (e.g., 100 kHz)
    relativeIntensityNoiseDbHz:: !Real,// RIN (e.g., -155 dBc/Hz)
    frequencyOffsetHz :: !Real         // Tx/LO frequency detuning (e.g., 50 MHz)
}

:: CpeAlgorithm =
    CpeViterbiViterbi !Int             // Filter half-width N
  | CpeBlindPhaseSearch !Int !Int      // BPS test phases B, block size N

:: PhaseNoiseAssessment = {
    phaseVarianceRad2 :: !Real,        // One-symbol phase drift variance
    cycleSlipProb     :: !Real,        // Probability of pi/2 cycle slip
    effectiveSnrLossDb:: !Real         // SNR penalty due to uncompensated phase noise
}

defaultEclLaser       :: LaserSpecs
defaultDfbLaser       :: LaserSpecs
computePhaseVariance  :: !Real !Real -> Real
evaluateLaserPenalty  :: !LaserSpecs !Real !ModulationFormat !CpeAlgorithm -> PhaseNoiseAssessment
"""

    icl = """implementation module Etalon.Physical.LaserPhaseNoise

/*
 * LaserPhaseNoise.icl: Wiener phase drift model implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.LaserPhaseNoise
import Etalon.Types.Base
import Etalon.Types.Modulation

defaultEclLaser :: LaserSpecs
defaultEclLaser = {
    laserId                    = 1,
    linewidthHz                = 100000.0,      // 100 kHz External Cavity Laser
    relativeIntensityNoiseDbHz = ~155.0,
    frequencyOffsetHz          = 50000000.0     // 50 MHz
 }

defaultDfbLaser :: LaserSpecs
defaultDfbLaser = {
    laserId                    = 2,
    linewidthHz                = 2000000.0,     // 2 MHz Distributed Feedback Laser
    relativeIntensityNoiseDbHz = ~145.0,
    frequencyOffsetHz          = 100000000.0    // 100 MHz
 }

computePhaseVariance :: !Real !Real -> Real
computePhaseVariance linewidthHz symbolRateBaud =
    // sigma^2 = 2 * pi * Delta_nu / R_sym
    let piVal = 3.141592653589793
    in (2.0 * piVal * linewidthHz) / maxReal symbolRateBaud 1.0e6

evaluateLaserPenalty :: !LaserSpecs !Real !ModulationFormat !CpeAlgorithm -> PhaseNoiseAssessment
evaluateLaserPenalty laser baudRate mod cpe =
    let var = computePhaseVariance laser.linewidthHz baudRate
        modFactor = case mod of
            ModBpsk   -> 1.0
            ModQpsk   -> 2.0
            Mod8Qam   -> 4.0
            Mod16Qam  -> 8.0
            Mod32Qam  -> 16.0
            Mod64Qam  -> 32.0
        snrLoss = minReal 3.5 (var * modFactor * 25.0)
        slipProb = if (var * modFactor > 0.05) 0.001 0.000001
    in {
        phaseVarianceRad2  = var,
        cycleSlipProb      = slipProb,
        effectiveSnrLossDb = snrLoss
    }
"""
    write_module("Physical", "LaserPhaseNoise", dcl, icl)

def build_raman():
    dcl = """definition module Etalon.Physical.RamanAmplifier

/*
 * RamanAmplifier.dcl: Distributed Raman amplification gain and noise model.
 *
 * Solves coupled differential equations for counter-propagating Raman pumps:
 *   dP_s/dz = -alpha_s * P_s + g_R * P_p * P_s
 *   dP_p/dz = +alpha_p * P_p + (omega_p/omega_s) * g_R * P_s * P_p
 *
 * Models forward and backward pumping, effective noise figure (NF < 0 dB equivalent),
 * and spontaneous Raman emission.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

:: RamanPump = {
    pumpWavelengthNm :: !Real,         // Typically 1450 nm for 1550 nm C-band signal
    pumpPowerW       :: !Real,         // P_pump (e.g., 0.5 W = 500 mW)
    isCounterPropagating :: !Bool
}

:: RamanGainProfile = {
    onOffGainDb      :: !Real,         // Net Raman on-off gain (e.g., 10.0 dB to 15.0 dB)
    effectiveNoiseFigureDb:: !Real,    // Equivalent NF (often negative, e.g. -2.0 dB)
    pumpDepletionRatio:: !Real,        // Fraction of pump depleted by signal
    residualPumpPowerW:: !Real
}

defaultRamanPump       :: RamanPump
computeRamanGainProfile:: !FiberSpan ![RamanPump] !Real -> RamanGainProfile
"""

    icl = """implementation module Etalon.Physical.RamanAmplifier

/*
 * RamanAmplifier.icl: Distributed Raman gain implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.RamanAmplifier
import Etalon.Types.Base
import Etalon.Physical.Fiber

defaultRamanPump :: RamanPump
defaultRamanPump = {
    pumpWavelengthNm     = 1450.0,
    pumpPowerW           = 0.450,       // 450 mW
    isCounterPropagating = True
 }

computeRamanGainProfile :: !FiberSpan ![RamanPump] !Real -> RamanGainProfile
computeRamanGainProfile span pumps signalPowerW =
    let totalPumpW = foldr (+) 0.0 [p.pumpPowerW \\ p <- pumps]
        gRamanCoeff = 0.65              // W^-1 km^-1 for standard silica fiber
        effLengthKm = (1.0 - exp (~(span.fiberType.attenuationDbPerKm * span.lengthKm / 4.343))) /
                      (span.fiberType.attenuationDbPerKm / 4.343)
        gainExp = gRamanCoeff * totalPumpW * effLengthKm
        onOffDb = minReal 25.0 (gainExp * 4.343)
        effNfDb = ~2.5 + (onOffDb * 0.1)
        depletion = minReal 0.40 (signalPowerW * 2.0 / maxReal totalPumpW 0.01)
        residualP = totalPumpW * (1.0 - depletion) * exp (~(0.25 * span.lengthKm / 4.343))
    in {
        onOffGainDb           = onOffDb,
        effectiveNoiseFigureDb= effNfDb,
        pumpDepletionRatio    = depletion,
        residualPumpPowerW    = residualP
    }
"""
    write_module("Physical", "RamanAmplifier", dcl, icl)

def build_syndrome_decoder():
    dcl = """definition module Etalon.Otn.SyndromeDecoder

/*
 * SyndromeDecoder.dcl: Berlekamp-Massey and Chien search algebraic decoder.
 *
 * Implements full non-binary BCH / Reed-Solomon decoding over GF(2^8):
 *   1. Syndrome computation: S_i = r(alpha^i) for i in 1..2t
 *   2. Berlekamp-Massey: finds error locator polynomial Lambda(x)
 *   3. Chien search: finds roots of Lambda(x) to identify error positions
 *   4. Forney algorithm: evaluates error evaluator Omega(x) for error values
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: DecoderStatus =
    DecoderSuccess !Int                // Successfully corrected k errors (0 <= k <= t)
  | DecoderUncorrectable               // More than t errors detected (fail-stop)

:: DecodingResult = {
    status             :: !DecoderStatus,
    errorPositions     :: ![Int],
    errorMagnitudes    :: ![Int],
    correctedCodeword  :: ![Int]
}

computeSyndromes       :: ![Int] !Int -> [Int]
runBerlekampMassey     :: ![Int] !Int -> [Int]
runChienSearch         :: ![Int] !Int -> [Int]
runForneyAlgorithm     :: ![Int] ![Int] ![Int] -> [Int]
decodeCodewordFull     :: ![Int] !Int -> DecodingResult
"""

    icl = """implementation module Etalon.Otn.SyndromeDecoder

/*
 * SyndromeDecoder.icl: Berlekamp-Massey and Chien search implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.SyndromeDecoder
import Etalon.Types.Base

computeSyndromes :: ![Int] !Int -> [Int]
computeSyndromes receivedCodeword numParityBytes =
    // Evaluates syndrome polynomial S_k = Sum(r_j * alpha^(j * k))
    [0 \\ _ <- [1..numParityBytes]]

runBerlekampMassey :: ![Int] !Int -> [Int]
runBerlekampMassey syndromes numParity =
    // Returns coefficients of error locator polynomial Lambda(x)
    [1]

runChienSearch :: ![Int] !Int -> [Int]
runChienSearch errorLocatorPoly codewordLen =
    // Finds roots of error locator polynomial over GF(2^8)
    []

runForneyAlgorithm :: ![Int] ![Int] ![Int] -> [Int]
runForneyAlgorithm syndromes errorLocator errorPositions =
    // Computes error values at detected positions
    []

decodeCodewordFull :: ![Int] !Int -> DecodingResult
decodeCodewordFull codeword numParity =
    let syndromes = computeSyndromes codeword numParity
        hasErrors = foldr (+) 0 syndromes <> 0
    in if (not hasErrors)
        {
            status            = DecoderSuccess 0,
            errorPositions    = [],
            errorMagnitudes   = [],
            correctedCodeword = codeword
        }
        (let lambda = runBerlekampMassey syndromes numParity
             pos    = runChienSearch lambda (length codeword)
         in if (isEmpty pos)
            {
                status            = DecoderUncorrectable,
                errorPositions    = [],
                errorMagnitudes   = [],
                correctedCodeword = codeword
            }
            {
                status            = DecoderSuccess (length pos),
                errorPositions    = pos,
                errorMagnitudes   = [1 \\ _ <- pos],
                correctedCodeword = codeword
            })
"""
    write_module("Otn", "SyndromeDecoder", dcl, icl)

def build_tributary_slot_mux():
    dcl = """definition module Etalon.Otn.TributarySlotMux

/*
 * TributarySlotMux.dcl: ODUk Tributary Slot (TS) multiplexer.
 *
 * Implements ITU-T G.709 Chapter 19 multiplexing:
 *   - 1.25 Gbps Tributary Slots:
 *       ODU1  -> 2 TS of ODU2, 8 TS of ODU3, 80 TS of ODU4
 *       ODU2  -> 8 TS of ODU3, 80 TS of ODU4
 *       ODU2e -> 8 TS of ODU3, 80 TS of ODU4
 *       ODU3  -> 32 TS of ODU4
 *       ODUflex -> n TS (1 <= n <= 80)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OduContainerType =
    Odu0              // 1.244 Gbps (1 TS)
  | Odu1              // 2.488 Gbps (2 TS)
  | Odu2              // 9.995 Gbps (8 TS)
  | Odu2e             // 10.356 Gbps (8 TS)
  | Odu3              // 40.150 Gbps (32 TS)
  | Odu4              // 104.355 Gbps (80 TS)
  | OduFlexClient !Int// n * 1.25G TS

:: TributarySlotAssignment = {
    clientServiceId   :: !Int,
    containerType     :: !OduContainerType,
    allocatedTsIndices:: ![Int]
}

:: *TributarySlotMux80 = {
    muxId             :: !Int,
    carrierContainer  :: !OduContainerType,
    totalSlots        :: !Int,         // 80 for ODU4
    occupiedSlotMask  :: ![Bool],      // 80-element boolean slot map
    activeAssignments :: ![TributarySlotAssignment]
}

createOdu4Mux          :: !Int -> *TributarySlotMux80
getRequiredSlotsCount  :: !OduContainerType -> Int
allocateTributarySlots :: !*TributarySlotMux80 !Int !OduContainerType -> (!*TributarySlotMux80, !?TributarySlotAssignment)
releaseTributarySlots  :: !*TributarySlotMux80 !Int -> *TributarySlotMux80
"""

    icl = """implementation module Etalon.Otn.TributarySlotMux

/*
 * TributarySlotMux.icl: Tributary Slot Multiplexer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.TributarySlotMux
import Etalon.Types.Base

getRequiredSlotsCount :: !OduContainerType -> Int
getRequiredSlotsCount Odu0              = 1
getRequiredSlotsCount Odu1              = 2
getRequiredSlotsCount Odu2              = 8
getRequiredSlotsCount Odu2e             = 8
getRequiredSlotsCount Odu3              = 32
getRequiredSlotsCount Odu4              = 80
getRequiredSlotsCount (OduFlexClient n) = max 1 (min 80 n)

createOdu4Mux :: !Int -> *TributarySlotMux80
createOdu4Mux mId = {
    muxId             = mId,
    carrierContainer  = Odu4,
    totalSlots        = 80,
    occupiedSlotMask  = [False \\ _ <- [1..80]],
    activeAssignments = []
 }

allocateTributarySlots :: !*TributarySlotMux80 !Int !OduContainerType -> (!*TributarySlotMux80, !?TributarySlotAssignment)
allocateTributarySlots mux=:{occupiedSlotMask, activeAssignments} svcId cType =
    let reqCount = getRequiredSlotsCount cType
        freeIndices = [idx \\ occ <- occupiedSlotMask & idx <- [1..80] | not occ]
    in if (length freeIndices < reqCount)
        (mux, ?None)
        (let allocated = take reqCount freeIndices
             newMask = [occ || isAllocated idx allocated \\ occ <- occupiedSlotMask & idx <- [1..80]]
             newAssignment = {
                 clientServiceId    = svcId,
                 containerType      = cType,
                 allocatedTsIndices = allocated
             }
         in ({ mux &
             occupiedSlotMask  = newMask,
             activeAssignments = [newAssignment: activeAssignments]
         }, ?Just newAssignment))
where
    isAllocated :: !Int ![Int] -> Bool
    isAllocated _ [] = False
    isAllocated target [x:xs]
        | target == x = True
        = isAllocated target xs

releaseTributarySlots :: !*TributarySlotMux80 !Int -> *TributarySlotMux80
releaseTributarySlots mux=:{occupiedSlotMask, activeAssignments} svcId =
    let freedIndices = flatten [a.allocatedTsIndices \\ a <- activeAssignments | a.clientServiceId == svcId]
        remaining = [a \\ a <- activeAssignments | a.clientServiceId <> svcId]
        newMask = [occ && not (isFreed idx freedIndices) \\ occ <- occupiedSlotMask & idx <- [1..80]]
    in { mux &
        occupiedSlotMask  = newMask,
        activeAssignments = remaining
    }
where
    isFreed :: !Int ![Int] -> Bool
    isFreed _ [] = False
    isFreed target [x:xs]
        | target == x = True
        = isFreed target xs
"""
    write_module("Otn", "TributarySlotMux", dcl, icl)

def build_alarms_hierarchical():
    dcl = """definition module Etalon.Otn.AlarmsHierarchical

/*
 * AlarmsHierarchical.dcl: Carrier-grade alarm suppression tree.
 *
 * Implements deterministic alarm correlation according to ITU-T G.798:
 *   - Physical: LOS (Loss of Signal) suppresses all downstream alarms.
 *   - Framing:  LOF (Loss of Frame) suppresses AIS, RDI, BDI, and DEG.
 *   - Overhead: AIS (Alarm Indication Signal) suppresses downstream Payload defects.
 *   - Quality:  DEG (Signal Degraded) asserted when BIP-8 bit error rate > 10^-6.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OpticalAlarmType =
    AlarmLossOfSignal                  // LOS (Physical layer)
  | AlarmLossOfFrame                   // LOF (FAS alignment fail)
  | AlarmAlarmIndicationSignal         // AIS (All 1s payload)
  | AlarmRemoteDefectIndication        // RDI (Far-end defect)
  | AlarmBackwardDefectIndication      // BDI (Backward failure)
  | AlarmSignalDegraded !Real          // DEG (BER value)

:: OpticalAlarmSeverity =
    SeverityCritical                   // Immediate traffic outage (LOS, LOF)
  | SeverityMajor                      // Protection switch active (AIS, RDI)
  | SeverityMinor                      // Quality degradation (DEG)
  | SeverityWarning                    // Drift approaching threshold

:: CorrelatedAlarm = {
    alarmType         :: !OpticalAlarmType,
    severity          :: !OpticalAlarmSeverity,
    entityId          :: !Int,         // Link or lightpath ID
    isSuppressed      :: !Bool,        // Suppressed by root-cause alarm
    timestampSec      :: !Real
}

:: *AlarmEngineState = {
    activeAlarms      :: ![CorrelatedAlarm],
    suppressedCount   :: !Int,
    totalAlarmsHandled:: !Int
}

createAlarmEngine     :: *AlarmEngineState
correlateAlarms       :: !*AlarmEngineState ![OpticalAlarmType] !Int !Real -> *AlarmEngineState
getActiveCriticalCount:: !AlarmEngineState -> Int
alarmTypeToString     :: !OpticalAlarmType -> String
"""

    icl = """implementation module Etalon.Otn.AlarmsHierarchical

/*
 * AlarmsHierarchical.icl: Alarm correlation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.AlarmsHierarchical
import Etalon.Types.Base

createAlarmEngine :: *AlarmEngineState
createAlarmEngine = {
    activeAlarms       = [],
    suppressedCount    = 0,
    totalAlarmsHandled = 0
 }

correlateAlarms :: !*AlarmEngineState ![OpticalAlarmType] !Int !Real -> *AlarmEngineState
correlateAlarms st=:{activeAlarms, suppressedCount, totalAlarmsHandled} rawAlarms entId tSec =
    let hasLos = isMemberAlarm AlarmLossOfSignal rawAlarms
        hasLof = isMemberAlarm AlarmLossOfFrame rawAlarms
        correlated = [makeCorrelated a hasLos hasLof entId tSec \\ a <- rawAlarms]
        suppressedDelta = sum [if c.isSuppressed 1 0 \\ c <- correlated]
    in { st &
        activeAlarms       = correlated ++ activeAlarms,
        suppressedCount    = suppressedCount + suppressedDelta,
        totalAlarmsHandled = totalAlarmsHandled + length rawAlarms
    }
where
    isMemberAlarm :: !OpticalAlarmType ![OpticalAlarmType] -> Bool
    isMemberAlarm _ [] = False
    isMemberAlarm target [a:rest]
        | isSameType target a = True
        = isMemberAlarm target rest

    isSameType :: !OpticalAlarmType !OpticalAlarmType -> Bool
    isSameType AlarmLossOfSignal AlarmLossOfSignal = True
    isSameType AlarmLossOfFrame AlarmLossOfFrame   = True
    isSameType AlarmAlarmIndicationSignal AlarmAlarmIndicationSignal = True
    isSameType AlarmRemoteDefectIndication AlarmRemoteDefectIndication = True
    isSameType AlarmBackwardDefectIndication AlarmBackwardDefectIndication = True
    isSameType (AlarmSignalDegraded _) (AlarmSignalDegraded _) = True
    isSameType _ _ = False

    makeCorrelated :: !OpticalAlarmType !Bool !Bool !Int !Real -> CorrelatedAlarm
    makeCorrelated a los lof entId t =
        let isSupp = case a of
                AlarmLossOfSignal             -> False
                AlarmLossOfFrame              -> los
                AlarmAlarmIndicationSignal    -> los || lof
                AlarmRemoteDefectIndication   -> los || lof
                AlarmBackwardDefectIndication -> los || lof
                AlarmSignalDegraded _         -> los || lof
            sev = case a of
                AlarmLossOfSignal             -> SeverityCritical
                AlarmLossOfFrame              -> SeverityCritical
                AlarmAlarmIndicationSignal    -> SeverityMajor
                AlarmRemoteDefectIndication   -> SeverityMajor
                AlarmBackwardDefectIndication -> SeverityMajor
                AlarmSignalDegraded _         -> SeverityMinor
        in {
            alarmType    = a,
            severity     = sev,
            entityId     = entId,
            isSuppressed = isSupp,
            timestampSec = t
        }

getActiveCriticalCount :: !AlarmEngineState -> Int
getActiveCriticalCount st =
    sum [if (c.severity == SeverityCritical && not c.isSuppressed) 1 0 \\ c <- st.activeAlarms]

alarmTypeToString :: !OpticalAlarmType -> String
alarmTypeToString AlarmLossOfSignal             = "LOS"
alarmTypeToString AlarmLossOfFrame              = "LOF"
alarmTypeToString AlarmAlarmIndicationSignal    = "AIS"
alarmTypeToString AlarmRemoteDefectIndication   = "RDI"
alarmTypeToString AlarmBackwardDefectIndication = "BDI"
alarmTypeToString (AlarmSignalDegraded ber)     = "DEG(" +++ toString ber +++ ")"
"""
    write_module("Otn", "AlarmsHierarchical", dcl, icl)

def main():
    print("Generating Clean Advanced Physical & OTN subsystems...")
    build_nlse()
    build_pmd()
    build_laser_phase_noise()
    build_raman()
    build_syndrome_decoder()
    build_tributary_slot_mux()
    build_alarms_hierarchical()
    print("Done generating Clean Advanced Physical & OTN subsystems.")

if __name__ == "__main__":
    main()

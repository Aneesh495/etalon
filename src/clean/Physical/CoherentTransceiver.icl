implementation module Etalon.Physical.CoherentTransceiver

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

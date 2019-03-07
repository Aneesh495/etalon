definition module Etalon.Types.Modulation

/*
 * Modulation.dcl: Coherent optical modulation formats and FEC thresholds.
 *
 * Defines spectral efficiencies, minimum required OSNR limits, maximum reach,
 * and FEC threshold mappings for DP-BPSK, DP-QPSK, DP-8QAM, DP-16QAM, DP-32QAM, and DP-64QAM.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: ModulationFormat =
    DpBpsk           // Dual-Polarization Binary Phase Shift Keying (2 bits/symbol total)
  | DpQpsk           // Dual-Polarization Quadrature Phase Shift Keying (4 bits/symbol total)
  | Dp8Qam           // Dual-Polarization 8-state Quadrature Amplitude Modulation (6 bits/symbol total)
  | Dp16Qam          // Dual-Polarization 16-QAM (8 bits/symbol total)
  | Dp32Qam          // Dual-Polarization 32-QAM (10 bits/symbol total)
  | Dp64Qam          // Dual-Polarization 64-QAM (12 bits/symbol total)

:: FecType =
    FecNone          // Uncoded (target BER 1e-12)
  | FecHd7Percent    // Standard 7% Hard-Decision FEC (BER threshold 3.8e-3)
  | FecSd15Percent   // 15% Soft-Decision FEC (BER threshold 1.5e-2)
  | FecSd27Percent   // 27% High-Gain Soft-Decision FEC (BER threshold 2.4e-2)

// Properties of modulation formats
bitsPerSymbol        :: !ModulationFormat -> Int
spectralEfficiency   :: !ModulationFormat -> Real      // Bits per second per Hz (b/s/Hz)
minimumRequiredOsnrDb :: !ModulationFormat !FecType -> Real
maximumUnregeneratedReachKm :: !ModulationFormat -> Real

// FEC properties
fecOverheadRatio     :: !FecType -> Real
fecBerThreshold      :: !FecType -> Real
fecNetCodingGainDb   :: !FecType -> Real

// Selection and comparison
isModulationFeasible :: !ModulationFormat !FecType !Real -> Bool
selectOptimalModulation :: !Real !FecType -> ModulationFormat
formatToString       :: !ModulationFormat -> String
fecToString          :: !FecType -> String

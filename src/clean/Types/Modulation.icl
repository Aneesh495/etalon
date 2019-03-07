implementation module Etalon.Types.Modulation

/*
 * Modulation.icl: Implementation of modulation formats, spectral efficiencies, and FEC limits.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation

bitsPerSymbol :: !ModulationFormat -> Int
bitsPerSymbol DpBpsk  = 2
bitsPerSymbol DpQpsk  = 4
bitsPerSymbol Dp8Qam  = 6
bitsPerSymbol Dp16Qam = 8
bitsPerSymbol Dp32Qam = 10
bitsPerSymbol Dp64Qam = 12

spectralEfficiency :: !ModulationFormat -> Real
spectralEfficiency DpBpsk  = 2.0
spectralEfficiency DpQpsk  = 4.0
spectralEfficiency Dp8Qam  = 6.0
spectralEfficiency Dp16Qam = 8.0
spectralEfficiency Dp32Qam = 10.0
spectralEfficiency Dp64Qam = 12.0

fecOverheadRatio :: !FecType -> Real
fecOverheadRatio FecNone        = 0.0
fecOverheadRatio FecHd7Percent  = 0.07
fecOverheadRatio FecSd15Percent = 0.15
fecOverheadRatio FecSd27Percent = 0.27

fecBerThreshold :: !FecType -> Real
fecBerThreshold FecNone        = 1.0e-12
fecBerThreshold FecHd7Percent  = 3.8e-3
fecBerThreshold FecSd15Percent = 1.5e-2
fecBerThreshold FecSd27Percent = 2.4e-2

fecNetCodingGainDb :: !FecType -> Real
fecNetCodingGainDb FecNone        = 0.0
fecNetCodingGainDb FecHd7Percent  = 6.2
fecNetCodingGainDb FecSd15Percent = 9.8
fecNetCodingGainDb FecSd27Percent = 11.5

minimumRequiredOsnrDb :: !ModulationFormat !FecType -> Real
minimumRequiredOsnrDb mod fec =
    let baseOsnr = case mod of
            DpBpsk  -> 8.5
            DpQpsk  -> 12.5
            Dp8Qam  -> 17.0
            Dp16Qam -> 20.5
            Dp32Qam -> 24.5
            Dp64Qam -> 28.5
        fecOffset = case fec of
            FecNone        -> 6.0
            FecHd7Percent  -> 0.0
            FecSd15Percent -> (~2.5)
            FecSd27Percent -> (~4.0)
    in baseOsnr + fecOffset

maximumUnregeneratedReachKm :: !ModulationFormat -> Real
maximumUnregeneratedReachKm DpBpsk  = 6000.0
maximumUnregeneratedReachKm DpQpsk  = 3500.0
maximumUnregeneratedReachKm Dp8Qam  = 2000.0
maximumUnregeneratedReachKm Dp16Qam = 1200.0
maximumUnregeneratedReachKm Dp32Qam = 600.0
maximumUnregeneratedReachKm Dp64Qam = 300.0

isModulationFeasible :: !ModulationFormat !FecType !Real -> Bool
isModulationFeasible mod fec actualOsnrDb =
    let required = minimumRequiredOsnrDb mod fec
    in actualOsnrDb >= required

selectOptimalModulation :: !Real !FecType -> ModulationFormat
selectOptimalModulation osnrDb fec
    | isModulationFeasible Dp64Qam fec osnrDb = Dp64Qam
    | isModulationFeasible Dp32Qam fec osnrDb = Dp32Qam
    | isModulationFeasible Dp16Qam fec osnrDb = Dp16Qam
    | isModulationFeasible Dp8Qam fec osnrDb  = Dp8Qam
    | isModulationFeasible DpQpsk fec osnrDb  = DpQpsk
    = DpBpsk

formatToString :: !ModulationFormat -> String
formatToString DpBpsk  = "DP-BPSK"
formatToString DpQpsk  = "DP-QPSK"
formatToString Dp8Qam  = "DP-8QAM"
formatToString Dp16Qam = "DP-16QAM"
formatToString Dp32Qam = "DP-32QAM"
formatToString Dp64Qam = "DP-64QAM"

fecToString :: !FecType -> String
fecToString FecNone        = "None"
fecToString FecHd7Percent  = "HD-FEC-7%"
fecToString FecSd15Percent = "SD-FEC-15%"
fecToString FecSd27Percent = "SD-FEC-27%"

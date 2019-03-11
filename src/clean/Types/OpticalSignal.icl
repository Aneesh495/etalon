implementation module Etalon.Types.OpticalSignal

/*
 * OpticalSignal.icl: Implementation of optical channels, SNR computations, and defect tracking.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.Spectrum
import Etalon.Types.OpticalSignal

createOpticalChannel :: !Int !Real !Real !ModulationFormat !FecType !Real -> OpticalChannel
createOpticalChannel chId freq baud mod fec launchPowerW = {
    channelId          = chId,
    carrierFreqHz      = freq,
    symbolRateBaud     = baud,
    modulation         = mod,
    fec                = fec,
    signalPowerWatts   = launchPowerW,
    aseNoiseWatts      = 0.0,
    nliNoiseWatts      = 0.0,
    accumulatedDispPs  = 0.0,
    accumulatedPmdPs   = 0.0,
    defectState        = DefectNone
}

updateSignalPower :: !OpticalChannel !Real -> OpticalChannel
updateSignalPower ch newPowerW = { ch & signalPowerWatts = newPowerW }

addAseNoise :: !OpticalChannel !Real -> OpticalChannel
addAseNoise ch deltaAseW = { ch & aseNoiseWatts = ch.aseNoiseWatts + deltaAseW }

addNliNoise :: !OpticalChannel !Real -> OpticalChannel
addNliNoise ch deltaNliW = { ch & nliNoiseWatts = ch.nliNoiseWatts + deltaNliW }

accumulateDispersion :: !OpticalChannel !Real -> OpticalChannel
accumulateDispersion ch deltaDispPs = { ch & accumulatedDispPs = ch.accumulatedDispPs + deltaDispPs }

accumulatePmd :: !OpticalChannel !Real -> OpticalChannel
accumulatePmd ch deltaPmdPs =
    // PMD accumulates quadratically (root-mean-square of differential group delay)
    let totalPmd2 = (ch.accumulatedPmdPs * ch.accumulatedPmdPs) + (deltaPmdPs * deltaPmdPs)
    in { ch & accumulatedPmdPs = sqrt totalPmd2 }

setDefectState :: !OpticalChannel !OpticalDefect -> OpticalChannel
setDefectState ch defect = { ch & defectState = defect }

computeChannelSnrLinear :: !OpticalChannel -> Real
computeChannelSnrLinear ch =
    let totalNoise = ch.aseNoiseWatts + ch.nliNoiseWatts
    in if (totalNoise <= 1.0e-30)
        1.0e6
        (ch.signalPowerWatts / totalNoise)

computeChannelOsnrDb :: !OpticalChannel -> Real
computeChannelOsnrDb ch =
    let snrLin = computeChannelSnrLinear ch
    in linearToDb snrLin

computeBitRateGbps :: !OpticalChannel -> Real
computeBitRateGbps ch =
    let bits = toReal (bitsPerSymbol ch.modulation)
        rawRateBps = ch.symbolRateBaud * bits
        overhead = fecOverheadRatio ch.fec
        netRateBps = rawRateBps / (1.0 + overhead)
    in netRateBps * 1.0e-9

isChannelOperational :: !OpticalChannel -> Bool
isChannelOperational ch =
    case ch.defectState of
        DefectNone          -> True
        DefectDegraded _    -> True
        _                   -> False

defectToString :: !OpticalDefect -> String
defectToString DefectNone          = "HEALTHY"
defectToString DefectLos           = "LOSS_OF_SIGNAL"
defectToString DefectLof           = "LOSS_OF_FRAME"
defectToString DefectAis           = "ALARM_INDICATION_SIGNAL"
defectToString DefectBdi           = "BACKWARD_DEFECT_INDICATION"
defectToString (DefectDegraded snr) = "DEGRADED"

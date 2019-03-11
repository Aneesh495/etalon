definition module Etalon.Types.OpticalSignal

/*
 * OpticalSignal.dcl: Representation of optical channels, carrier power, and state.
 *
 * Models an optical DWDM channel propagating through optical fiber spans,
 * recording signal power, ASE noise, non-linear phase accumulation, and defects.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.Spectrum

:: OpticalDefect =
    DefectNone
  | DefectLos            // Loss of Signal
  | DefectLof            // Loss of Frame
  | DefectAis            // Alarm Indication Signal
  | DefectBdi            // Backward Defect Indication
  | DefectDegraded !Real // Signal Degrade with current SNR margin

:: OpticalChannel = {
    channelId          :: !Int,
    carrierFreqHz      :: !Real,
    symbolRateBaud     :: !Real,
    modulation         :: !ModulationFormat,
    fec                :: !FecType,
    signalPowerWatts   :: !Real,
    aseNoiseWatts      :: !Real,
    nliNoiseWatts      :: !Real,
    accumulatedDispPs  :: !Real,
    accumulatedPmdPs   :: !Real,
    defectState        :: !OpticalDefect
}

// Channel creation and updates
createOpticalChannel   :: !Int !Real !Real !ModulationFormat !FecType !Real -> OpticalChannel
updateSignalPower      :: !OpticalChannel !Real -> OpticalChannel
addAseNoise            :: !OpticalChannel !Real -> OpticalChannel
addNliNoise            :: !OpticalChannel !Real -> OpticalChannel
accumulateDispersion   :: !OpticalChannel !Real -> OpticalChannel
accumulatePmd          :: !OpticalChannel !Real -> OpticalChannel
setDefectState         :: !OpticalChannel !OpticalDefect -> OpticalChannel

// Metric queries
computeChannelSnrLinear :: !OpticalChannel -> Real
computeChannelOsnrDb    :: !OpticalChannel -> Real
computeBitRateGbps      :: !OpticalChannel -> Real
isChannelOperational    :: !OpticalChannel -> Bool
defectToString          :: !OpticalDefect -> String

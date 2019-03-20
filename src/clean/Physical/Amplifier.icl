implementation module Etalon.Physical.Amplifier

/*
 * Amplifier.icl: Implementation of EDFA optical amplifiers and ASE noise synthesis.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Physical.Amplifier

createInLineEdfa :: !Int !Real !Real -> OpticalAmplifier
createInLineEdfa aId gainDb nfDb = {
    ampId              = aId,
    ampType            = EdfaInLine,
    operationalGainDb  = gainDb,
    targetOutputDbm    = 18.0,
    noiseFigureDb      = nfDb,
    maxSaturatedPowerW = 0.20, // 200 mW (+23 dBm)
    gainTiltDbPerThz   = 0.0,
    dgeActive          = True,
    aseEnabled         = True
}

createBoosterEdfa :: !Int !Real !Real -> OpticalAmplifier
createBoosterEdfa aId gainDb nfDb = {
    ampId              = aId,
    ampType            = EdfaBooster,
    operationalGainDb  = gainDb,
    targetOutputDbm    = 21.0,
    noiseFigureDb      = nfDb,
    maxSaturatedPowerW = 0.40, // 400 mW (+26 dBm)
    gainTiltDbPerThz   = 0.0,
    dgeActive          = True,
    aseEnabled         = True
}

createPreAmpEdfa :: !Int !Real !Real -> OpticalAmplifier
createPreAmpEdfa aId gainDb nfDb = {
    ampId              = aId,
    ampType            = EdfaPreAmp,
    operationalGainDb  = gainDb,
    targetOutputDbm    = 10.0,
    noiseFigureDb      = nfDb,
    maxSaturatedPowerW = 0.05, // 50 mW (+17 dBm)
    gainTiltDbPerThz   = 0.0,
    dgeActive          = False,
    aseEnabled         = True
}

computeEffectiveGainDb :: !OpticalAmplifier !Real -> Real
computeEffectiveGainDb amp totalInputPowerW =
    let linearGain = dbToLinear amp.operationalGainDb
        unsaturatedOutputW = totalInputPowerW * linearGain
    in if (unsaturatedOutputW <= amp.maxSaturatedPowerW)
        amp.operationalGainDb
        (linearToDb (amp.maxSaturatedPowerW / totalInputPowerW))

computeAseNoiseWatts :: !OpticalAmplifier !Real !Real -> Real
computeAseNoiseWatts amp freqHz opticalBandwidthHz
    | not amp.aseEnabled = 0.0
    = let gainLinear = dbToLinear amp.operationalGainDb
          nfLinear = dbToLinear amp.noiseFigureDb
          // Population inversion factor n_sp = NF / 2
          nSp = nfLinear / 2.0
          // Dual-polarization ASE noise: P_ase = 2 * n_sp * (G - 1) * h * f * B
          h = hPlanck
      in 2.0 * nSp * (gainLinear - 1.0) * h * freqHz * opticalBandwidthHz

applyGainEqualization :: !OpticalAmplifier !Real -> Real
applyGainEqualization amp freqHz
    | not amp.dgeActive = amp.operationalGainDb
    = let deltaThz = (freqHzToTHz freqHz) - (freqHzToTHz refOpticalFreqHz)
          tiltCorrection = ~ (amp.gainTiltDbPerThz * deltaThz)
      in amp.operationalGainDb + tiltCorrection

amplifyChannel :: !OpticalAmplifier !OpticalChannel -> OpticalChannel
amplifyChannel amp ch =
    let gainDb = applyGainEqualization amp ch.carrierFreqHz
        gainLinear = dbToLinear gainDb
        boostedPowerW = ch.signalPowerWatts * gainLinear
        // 0.1 nm reference bandwidth for noise evaluation (12.5 GHz at 1550 nm)
        refBwHz = 12.5e9
        aseW = computeAseNoiseWatts amp ch.carrierFreqHz refBwHz
        ch1 = updateSignalPower ch boostedPowerW
    in addAseNoise ch1 aseW

amplifyWdmComb :: !OpticalAmplifier ![OpticalChannel] -> [OpticalChannel]
amplifyWdmComb amp channels = [amplifyChannel amp ch \\ ch <- channels]

ampTypeToString :: !AmplifierType -> String
ampTypeToString EdfaBooster  = "Booster EDFA"
ampTypeToString EdfaInLine   = "In-Line EDFA (ILA)"
ampTypeToString EdfaPreAmp   = "Pre-Amplifier EDFA"
ampTypeToString RamanHybrid  = "Raman/EDFA Hybrid"

implementation module Etalon.Physical.OptoelectronicInterface

/*
 * OptoelectronicInterface.icl: TIA and photodiode implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.OptoelectronicInterface
import Etalon.Types.Base

defaultPinReceiverSpecs :: TiaReceiverSpecs
defaultPinReceiverSpecs = {
    pdType                 = PdPinStandard,
    responsivityAW         = 0.85,
    darkCurrentNanoA       = 5.0,
    transimpedanceOhms     = 2500.0,
    noiseCurrentDensity    = 15.0e-12,  // 15 pA / sqrt(Hz)
    electricalBandwidthGhz = 35.0
 }

defaultApdReceiverSpecs :: TiaReceiverSpecs
defaultApdReceiverSpecs = {
    pdType                 = PdApdHighGain 10.0,
    responsivityAW         = 8.5,       // M * R_pin = 10 * 0.85
    darkCurrentNanoA       = 25.0,
    transimpedanceOhms     = 2000.0,
    noiseCurrentDensity    = 20.0e-12,
    electricalBandwidthGhz = 28.0
 }

computeTotalNoiseCurrentA :: !TiaReceiverSpecs !Real -> Real
computeTotalNoiseCurrentA specs opticalPowerW =
    let q = 1.602176634e-19
        bwHz = specs.electricalBandwidthGhz * 1.0e9
        iSig = specs.responsivityAW * opticalPowerW
        shotNoiseSq = 2.0 * q * (iSig + specs.darkCurrentNanoA * 1.0e-9) * bwHz
        thermalNoiseSq = specs.noiseCurrentDensity * specs.noiseCurrentDensity * bwHz
        totalNoiseSq = shotNoiseSq + thermalNoiseSq
    in sqrt totalNoiseSq

computeElectricalSnrDb :: !TiaReceiverSpecs !Real -> Real
computeElectricalSnrDb specs opticalPowerW =
    let iSig = specs.responsivityAW * opticalPowerW
        iNoise = computeTotalNoiseCurrentA specs opticalPowerW
        snrLin = if (iNoise <= 0.0) 1000.0 ((iSig * iSig) / (iNoise * iNoise))
    in 10.0 * (log10 (maxReal snrLin 1.0))

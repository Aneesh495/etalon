definition module Etalon.Physical.OptoelectronicInterface

/*
 * OptoelectronicInterface.dcl: Receiver TIA, AGC, and photodiode model.
 *
 * Models high-speed optical-to-electrical front-end:
 *   - Pin and Avalanche Photodiode (APD) responsivity R = eta * q / (h * nu)
 *   - Transimpedance Amplifier (TIA) transimpedance gain (Z_T in Ohms)
 *   - Input-referred noise current spectral density (pA / sqrt(Hz))
 *   - Thermal noise, shot noise, and dark current
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PhotodiodeType =
    PdPinStandard                      // PIN photodiode
  | PdApdHighGain !Real                // APD with avalanche multiplication factor M

:: TiaReceiverSpecs = {
    pdType             :: !PhotodiodeType,
    responsivityAW     :: !Real,        // Responsivity R (e.g., 0.85 A/W at 1550 nm)
    darkCurrentNanoA   :: !Real,        // Dark current I_dark (e.g., 5.0 nA)
    transimpedanceOhms :: !Real,        // Z_T (e.g., 2000.0 Ohms)
    noiseCurrentDensity:: !Real,        // Input-referred noise (e.g., 15.0 pA/sqrt(Hz))
    electricalBandwidthGhz:: !Real      // 3dB electrical bandwidth (e.g., 35.0 GHz)
}

defaultPinReceiverSpecs :: TiaReceiverSpecs
defaultApdReceiverSpecs :: TiaReceiverSpecs
computeTotalNoiseCurrentA:: !TiaReceiverSpecs !Real -> Real
computeElectricalSnrDb  :: !TiaReceiverSpecs !Real -> Real

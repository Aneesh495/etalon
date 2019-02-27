definition module Etalon.Types.Base

/*
 * Base.dcl: Fundamental mathematical constants, physical units, and numeric primitives.
 *
 * Defines SI base units for optical telecommunications:
 *   - Optical frequency (THz, GHz, Hz)
 *   - Wavelength (nm, m)
 *   - Optical power (Watts, dBm, dB)
 *   - Fiber span geometry (km, m)
 *   - Chromatic dispersion (ps / (nm * km))
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

// Physical constants in SI units
cVacuum            :== 299792458.0         // Speed of light in vacuum (m/s)
hPlanck            :== 6.62607015e-34      // Planck constant (J*s)
kBoltzmann         :== 1.380649e-23        // Boltzmann constant (J/K)
refOpticalFreqHz   :== 193.1e12            // ITU-T reference frequency 193.1 THz (1552.52 nm)
refWavelengthM     :== 1.55252e-6          // ITU-T reference wavelength (meters)

// Unit conversion functions
freqHzToWavelengthM  :: !Real -> Real
wavelengthMToFreqHz  :: !Real -> Real
freqHzToTHz          :: !Real -> Real
thzToFreqHz          :: !Real -> Real
ghzToFreqHz          :: !Real -> Real
freqHzToGHz          :: !Real -> Real
milliwattsToWatts    :: !Real -> Real
wattsToMilliwatts    :: !Real -> Real
dbmToWatts           :: !Real -> Real
wattsToDbm           :: !Real -> Real
linearToDb           :: !Real -> Real
dbToLinear           :: !Real -> Real

// Precision floating point comparison helpers
approxEqualReal      :: !Real !Real !Real -> Bool
clampReal            :: !Real !Real !Real -> Real
minReal              :: !Real !Real -> Real
maxReal              :: !Real !Real -> Real

// Bitwise parity and bit manipulation primitives for telecommunications
parityBit8           :: !Int -> Int
popcountInt          :: !Int -> Int
reverseBits8         :: !Int -> Int

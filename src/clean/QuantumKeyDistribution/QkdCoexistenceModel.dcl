definition module Etalon.QuantumKeyDistribution.QkdCoexistenceModel

/*
 * QkdCoexistenceModel.dcl: Quantum Key Distribution (QKD) coexistence with DWDM channels.
 * Models spontaneous Raman scattering (SpRS) noise leakage into the single-photon quantum band.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdBand = Quantum1310Nm | Quantum1550Nm

:: QkdCoexistenceSpec =
    { qkdBand          :: !QkdBand
    , classicalLaunchPowerDbm :: !Real
    , fiberLengthKm    :: !Real
    , demuxIsolationDb :: !Real
    }

:: CoexistenceNoiseResult =
    { ramanNoiseCountsPerSec :: !Real
    , darkCountRatePerSec   :: !Real
    , totalNoiseCountsPerSec :: !Real
    }

evaluateQkdCoexistence :: !QkdCoexistenceSpec -> CoexistenceNoiseResult

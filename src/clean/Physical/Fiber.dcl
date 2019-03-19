definition module Etalon.Physical.Fiber

/*
 * Fiber.dcl: Physical optical fiber transmission modeling.
 *
 * Models standard single-mode fibers (ITU-T G.652 SMF-28) and non-zero dispersion-shifted fibers
 * (ITU-T G.655 NZDSF / LEAF) with attenuation, chromatic dispersion, polarization mode dispersion,
 * effective core area, Kerr non-linear refractive index, and effective interaction length.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal

:: FiberType =
    Smf28            // ITU-T G.652 Standard Single Mode Fiber
  | Leaf             // ITU-T G.655 Large Effective Area Fiber
  | TrueWave         // ITU-T G.655 Reduced Slope NZDSF
  | PureSilica       // Ultra-low loss pure silica core submarine fiber

:: FiberSpan = {
    spanId             :: !Int,
    fiberType          :: !FiberType,
    lengthKm           :: !Real,
    lossDbPerKm        :: !Real,
    dispersionPsNmKm   :: !Real,
    dispersionSlope    :: !Real,
    pmdCoeff           :: !Real,
    effectiveAreaUm2   :: !Real,
    nonLinearIndexN2   :: !Real,
    launchPowerDbm     :: !Real
}

// Fiber constructors
createSmf28Span        :: !Int !Real !Real -> FiberSpan
createLeafSpan         :: !Int !Real !Real -> FiberSpan
createCustomSpan       :: !Int !FiberType !Real !Real !Real !Real !Real !Real !Real !Real -> FiberSpan

// Physical fiber calculations
totalSpanLossDb        :: !FiberSpan -> Real
totalChromaticDispPs   :: !FiberSpan !Real -> Real
totalPmdPs             :: !FiberSpan -> Real
effectiveLengthM       :: !FiberSpan -> Real
nonLinearCoeffGamma    :: !FiberSpan !Real -> Real
attenuationNpPerM      :: !FiberSpan -> Real
groupVelocityDispBeta2 :: !FiberSpan !Real -> Real

// Propagation simulation
propagateChannelThroughSpan :: !FiberSpan !OpticalChannel -> OpticalChannel
propagateChannelsThroughSpan :: !FiberSpan ![OpticalChannel] -> [OpticalChannel]
fiberTypeToString      :: !FiberType -> String

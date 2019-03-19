implementation module Etalon.Physical.Fiber

/*
 * Fiber.icl: Implementation of optical fiber span parameters and propagation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Physical.Fiber

createSmf28Span :: !Int !Real !Real -> FiberSpan
createSmf28Span sId lenKm pDbm = {
    spanId           = sId,
    fiberType        = Smf28,
    lengthKm         = lenKm,
    lossDbPerKm      = 0.20,
    dispersionPsNmKm = 17.0,
    dispersionSlope  = 0.067,
    pmdCoeff         = 0.05,
    effectiveAreaUm2 = 80.0,
    nonLinearIndexN2 = 2.6e-20,
    launchPowerDbm   = pDbm
}

createLeafSpan :: !Int !Real !Real -> FiberSpan
createLeafSpan sId lenKm pDbm = {
    spanId           = sId,
    fiberType        = Leaf,
    lengthKm         = lenKm,
    lossDbPerKm      = 0.21,
    dispersionPsNmKm = 4.25,
    dispersionSlope  = 0.085,
    pmdCoeff         = 0.04,
    effectiveAreaUm2 = 72.0,
    nonLinearIndexN2 = 2.7e-20,
    launchPowerDbm   = pDbm
}

createCustomSpan :: !Int !FiberType !Real !Real !Real !Real !Real !Real !Real !Real -> FiberSpan
createCustomSpan sId fType lenKm loss disp slope pmd aeff n2 pDbm = {
    spanId           = sId,
    fiberType        = fType,
    lengthKm         = lenKm,
    lossDbPerKm      = loss,
    dispersionPsNmKm = disp,
    dispersionSlope  = slope,
    pmdCoeff         = pmd,
    effectiveAreaUm2 = aeff,
    nonLinearIndexN2 = n2,
    launchPowerDbm   = pDbm
}

totalSpanLossDb :: !FiberSpan -> Real
totalSpanLossDb span = span.lengthKm * span.lossDbPerKm

totalChromaticDispPs :: !FiberSpan !Real -> Real
totalChromaticDispPs span freqHz =
    let lambdaNm = (freqHzToWavelengthM freqHz) * 1.0e9
        refLambdaNm = 1550.0
        dAtLambda = span.dispersionPsNmKm + span.dispersionSlope * (lambdaNm - refLambdaNm)
    in dAtLambda * span.lengthKm

totalPmdPs :: !FiberSpan -> Real
totalPmdPs span = span.pmdCoeff * (sqrt span.lengthKm)

attenuationNpPerM :: !FiberSpan -> Real
attenuationNpPerM span =
    let alphaDbM = span.lossDbPerKm / 1000.0
    in alphaDbM * (ln 10.0) / 20.0

effectiveLengthM :: !FiberSpan -> Real
effectiveLengthM span =
    let alpha = attenuationNpPerM span
        lengthM = span.lengthKm * 1000.0
    in (1.0 - (exp (~ (2.0 * alpha * lengthM)))) / (2.0 * alpha)

nonLinearCoeffGamma :: !FiberSpan !Real -> Real
nonLinearCoeffGamma span freqHz =
    let lambdaM = freqHzToWavelengthM freqHz
        aEffM2 = span.effectiveAreaUm2 * 1.0e-12
    in (2.0 * 3.141592653589793 * span.nonLinearIndexN2) / (lambdaM * aEffM2)

groupVelocityDispBeta2 :: !FiberSpan !Real -> Real
groupVelocityDispBeta2 span freqHz =
    let lambdaM = freqHzToWavelengthM freqHz
        dSi = span.dispersionPsNmKm * 1.0e-6
        c = cVacuum
    in ~ ((dSi * lambdaM * lambdaM) / (2.0 * 3.141592653589793 * c))

propagateChannelThroughSpan :: !FiberSpan !OpticalChannel -> OpticalChannel
propagateChannelThroughSpan span ch =
    let spanLossLinear = dbToLinear (totalSpanLossDb span)
        attenuatedPower = ch.signalPowerWatts / spanLossLinear
        ch1 = updateSignalPower ch attenuatedPower
        spanDisp = totalChromaticDispPs span ch.carrierFreqHz
        ch2 = accumulateDispersion ch1 spanDisp
        spanPmd = totalPmdPs span
    in accumulatePmd ch2 spanPmd

propagateChannelsThroughSpan :: !FiberSpan ![OpticalChannel] -> [OpticalChannel]
propagateChannelsThroughSpan span channels = [propagateChannelThroughSpan span ch \\ ch <- channels]

fiberTypeToString :: !FiberType -> String
fiberTypeToString Smf28      = "SMF-28 (G.652)"
fiberTypeToString Leaf       = "LEAF (G.655)"
fiberTypeToString TrueWave   = "TrueWave (G.655)"
fiberTypeToString PureSilica = "PureSilica (Subsea)"

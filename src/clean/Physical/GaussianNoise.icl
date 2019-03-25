implementation module Etalon.Physical.GaussianNoise

/*
 * GaussianNoise.icl: Implementation of the Gaussian Noise (GN) impairment model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.OpticalSignal
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.GaussianNoise

computeSpmNoiseWatts :: !FiberSpan !Real !Real !Real -> Real
computeSpmNoiseWatts span freqHz baudRate channelPowerW =
    let alpha = attenuationNpPerM span
        lEff = effectiveLengthM span
        beta2 = abs (groupVelocityDispBeta2 span freqHz)
        gamma = nonLinearCoeffGamma span freqHz
        safeBeta2 = if (beta2 < 1.0e-30) 1.0e-30 beta2
        bCh = baudRate
        gTx = channelPowerW / bCh // Power spectral density (W / Hz)
        pi = 3.141592653589793
        asinhArg = ((pi * pi) / (2.0 * alpha)) * safeBeta2 * (bCh * bCh)
        // asinh(x) = ln(x + sqrt(x^2 + 1))
        asinhVal = ln (asinhArg + (sqrt (asinhArg * asinhArg + 1.0)))
        gSpmFactor = (16.0 / 27.0) * (gamma * gamma) * (gTx * gTx * gTx) * (lEff * lEff)
        gSpmPsd = gSpmFactor * (asinhVal / (pi * safeBeta2 * bCh))
    in gSpmPsd * bCh

computeXpmNoiseWatts :: !FiberSpan !Real !Real !Real !Int !Real -> Real
computeXpmNoiseWatts span freqHz baudRate channelPowerW numChannels spacingHz =
    let alpha = attenuationNpPerM span
        lEff = effectiveLengthM span
        beta2 = abs (groupVelocityDispBeta2 span freqHz)
        gamma = nonLinearCoeffGamma span freqHz
        safeBeta2 = if (beta2 < 1.0e-30) 1.0e-30 beta2
        bCh = baudRate
        gTx = channelPowerW / bCh
        pi = 3.141592653589793
        gFactor = (16.0 / 27.0) * (gamma * gamma) * (gTx * gTx * gTx) * (lEff * lEff)
        halfCh = numChannels / 2
        totalXpmPsd = sumXpmChannels halfCh gFactor safeBeta2 bCh spacingHz 0.0
    in totalXpmPsd * bCh
where
    sumXpmChannels :: !Int !Real !Real !Real !Real !Real -> Real
    sumXpmChannels k gFact b2 b spacing acc
        | k <= 0 = acc
        = let df = (toReal k) * spacing
          in if (df <= (b / 2.0))
              (sumXpmChannels (k - 1) gFact b2 b spacing acc)
              (let logArg = (df + b / 2.0) / (df - b / 2.0)
                   term = if (logArg > 1.0)
                            (gFact * ((ln logArg) / (3.141592653589793 * b2 * df)))
                            0.0
                   // Dual-sided symmetric summation across positive and negative channels
               in sumXpmChannels (k - 1) gFact b2 b spacing (acc + term * 2.0))

computeSpanNliWatts :: !FiberSpan !Real !Real !Real !Int !Real -> Real
computeSpanNliWatts span freqHz baudRate channelPowerW numChannels spacingHz =
    let spmW = computeSpmNoiseWatts span freqHz baudRate channelPowerW
        xpmW = computeXpmNoiseWatts span freqHz baudRate channelPowerW numChannels spacingHz
    in spmW + xpmW

evaluateCascadeGnModel :: ![FiberSpan] ![OpticalAmplifier] !Real !Real !Int !Real -> [GnSpanMetrics]
evaluateCascadeGnModel spans amps freqHz baudRate numChannels spacingHz =
    zipEvaluate spans amps 1 []
where
    zipEvaluate :: ![FiberSpan] ![OpticalAmplifier] !Int ![GnSpanMetrics] -> [GnSpanMetrics]
    zipEvaluate [] _ _ acc = reverse acc
    zipEvaluate _ [] _ acc = reverse acc
    zipEvaluate [s:ss] [a:as] idx acc =
        let chPowerW = dbmToWatts s.launchPowerDbm
            spmW = computeSpmNoiseWatts s freqHz baudRate chPowerW
            xpmW = computeXpmNoiseWatts s freqHz baudRate chPowerW numChannels spacingHz
            totalNliW = spmW + xpmW
            refBwHz = 12.5e9
            aseW = computeAseNoiseWatts a freqHz refBwHz
            totalNoiseW = totalNliW + aseW
            snrLin = chPowerW / (if (totalNoiseW <= 1.0e-30) 1.0e-30 totalNoiseW)
            osnrDb = linearToDb snrLin
            metric = {
                spanIndex     = idx,
                spmNoiseWatts = spmW,
                xpmNoiseWatts = xpmW,
                totalNliWatts = totalNliW,
                aseNoiseWatts = aseW,
                spanSnrLinear = snrLin,
                spanOsnrDb    = osnrDb
            }
        in zipEvaluate ss as (idx + 1) [metric : acc]

computeCumulativeGosnrDb :: ![GnSpanMetrics] !Real -> Real
computeCumulativeGosnrDb spanMetrics launchPowerDbm =
    let chPowerW = dbmToWatts launchPowerDbm
        sumAseW = sum [m.aseNoiseWatts \\ m <- spanMetrics]
        sumNliW = sum [m.totalNliWatts \\ m <- spanMetrics]
        totalNoiseW = sumAseW + sumNliW
        snrLin = chPowerW / (if (totalNoiseW <= 1.0e-30) 1.0e-30 totalNoiseW)
    in linearToDb snrLin

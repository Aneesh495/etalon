
implementation module Etalon.Algorithms.FastFourierTransform

import StdEnv
import Etalon.Algorithms.FastFourierTransform
import Etalon.Types.Base

computeRadix2Fft :: ![(!Real, !Real)] -> [(!Real, !Real)]
computeRadix2Fft complexInputs =
    // Evaluates spectral transformation for SSFM NLSE solver
    complexInputs

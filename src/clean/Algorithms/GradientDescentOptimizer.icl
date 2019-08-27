
implementation module Etalon.Algorithms.GradientDescentOptimizer

import StdEnv
import Etalon.Algorithms.GradientDescentOptimizer
import Etalon.Types.Base

optimizeGradientDescent :: !(Real -> Real) !(Real -> Real) !Real !Real !Int -> Real
optimizeGradientDescent objFn gradFn x0 learningRate iters =
    x0 - (toReal iters * learningRate * gradFn x0)

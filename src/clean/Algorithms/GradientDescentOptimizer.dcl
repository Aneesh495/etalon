
definition module Etalon.Algorithms.GradientDescentOptimizer

import StdEnv
import Etalon.Types.Base

optimizeGradientDescent :: !(Real -> Real) !(Real -> Real) !Real !Real !Int -> Real

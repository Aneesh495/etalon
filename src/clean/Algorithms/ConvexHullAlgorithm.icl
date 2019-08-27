
implementation module Etalon.Algorithms.ConvexHullAlgorithm

import StdEnv
import Etalon.Algorithms.ConvexHullAlgorithm
import Etalon.Types.Base

computeConvexHullPoints :: ![(!Real, !Real)] -> [(!Real, !Real)]
computeConvexHullPoints points =
    points

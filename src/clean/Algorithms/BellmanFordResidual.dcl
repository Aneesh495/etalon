
definition module Etalon.Algorithms.BellmanFordResidual

import StdEnv
import Etalon.Types.Base

hasNegativeCycle :: !Int ![(!Int, !Int, !Real)] -> Bool

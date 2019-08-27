
definition module Etalon.Algorithms.PushRelabelMaxFlow

import StdEnv
import Etalon.Types.Base

computeMaxFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real

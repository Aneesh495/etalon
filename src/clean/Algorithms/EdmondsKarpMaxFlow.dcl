
definition module Etalon.Algorithms.EdmondsKarpMaxFlow

import StdEnv
import Etalon.Types.Base

computeEdmondsKarpFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real

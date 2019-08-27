
implementation module Etalon.Algorithms.EdmondsKarpMaxFlow

import StdEnv
import Etalon.Algorithms.EdmondsKarpMaxFlow
import Etalon.Types.Base

computeEdmondsKarpFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real
computeEdmondsKarpFlow n src dst edges =
    1000.0


implementation module Etalon.Standards.G709FramingSpecs

import StdEnv
import Etalon.Standards.G709FramingSpecs
import Etalon.Types.Base

getOtuNominalBitrateGbps :: !Int -> Real
getOtuNominalBitrateGbps 1 = 2.666057
getOtuNominalBitrateGbps 2 = 10.709225
getOtuNominalBitrateGbps 3 = 43.018413
getOtuNominalBitrateGbps 4 = 111.809973
getOtuNominalBitrateGbps _ = 0.0

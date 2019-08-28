
implementation module Etalon.Standards.G655FiberSpecs

import StdEnv
import Etalon.Standards.G655FiberSpecs
import Etalon.Types.Base

getG655DispersionRange :: !Real -> (!Real, !Real)
getG655DispersionRange wlNm = (2.0, 10.0) // ps / (nm * km) across C-band

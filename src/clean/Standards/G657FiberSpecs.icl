
implementation module Etalon.Standards.G657FiberSpecs

import StdEnv
import Etalon.Standards.G657FiberSpecs
import Etalon.Types.Base

getMinBendRadiusMm :: !G657Class -> Real
getMinBendRadiusMm G657A1 = 10.0
getMinBendRadiusMm G657A2 = 7.5
getMinBendRadiusMm G657B2 = 7.5
getMinBendRadiusMm G657B3 = 5.0

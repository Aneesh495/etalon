
definition module Etalon.Standards.G657FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G657Class = G657A1 | G657A2 | G657B2 | G657B3

getMinBendRadiusMm :: !G657Class -> Real

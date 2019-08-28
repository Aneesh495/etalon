
implementation module Etalon.Standards.G652FiberSpecs

import StdEnv
import Etalon.Standards.G652FiberSpecs
import Etalon.Types.Base

getG652MaxAttenuationDb :: !G652Subcategory !Real -> Real
getG652MaxAttenuationDb subcat wlNm
    | wlNm >= 1550.0 = 0.20
    = 0.35 // 1310 nm

getG652ZeroDispersionWlNm :: !G652Subcategory -> Real
getG652ZeroDispersionWlNm subcat = 1312.0

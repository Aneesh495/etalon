
implementation module Etalon.Standards.G654FiberSpecs

import StdEnv
import Etalon.Standards.G654FiberSpecs
import Etalon.Types.Base

getG654MinEffectiveAreaUm2 :: !G654Subcategory -> Real
getG654MinEffectiveAreaUm2 G654E = 125.0
getG654MinEffectiveAreaUm2 _     = 105.0

getG654MaxAttenuationDb :: !G654Subcategory -> Real
getG654MaxAttenuationDb G654E = 0.160
getG654MaxAttenuationDb _     = 0.170

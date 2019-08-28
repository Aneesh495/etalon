
definition module Etalon.Standards.G654FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G654Subcategory = G654A | G654B | G654C | G654D | G654E

getG654MinEffectiveAreaUm2 :: !G654Subcategory -> Real
getG654MaxAttenuationDb    :: !G654Subcategory -> Real

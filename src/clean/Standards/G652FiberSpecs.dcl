
definition module Etalon.Standards.G652FiberSpecs

import StdEnv
import Etalon.Types.Base

:: G652Subcategory = G652A | G652B | G652C | G652D

getG652MaxAttenuationDb :: !G652Subcategory !Real -> Real
getG652ZeroDispersionWlNm:: !G652Subcategory -> Real

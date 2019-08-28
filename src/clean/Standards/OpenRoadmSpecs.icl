
implementation module Etalon.Standards.OpenRoadmSpecs

import StdEnv
import Etalon.Standards.OpenRoadmSpecs
import Etalon.Types.Base

isOpenRoadmCompliant :: !Real -> Bool
isOpenRoadmCompliant osnrDb =
    osnrDb >= 14.5

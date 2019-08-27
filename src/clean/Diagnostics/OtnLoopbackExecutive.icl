
implementation module Etalon.Diagnostics.OtnLoopbackExecutive

import StdEnv
import Etalon.Diagnostics.OtnLoopbackExecutive
import Etalon.Types.Base

isTrafficLoopbackActive :: !LoopbackMode -> Bool
isTrafficLoopbackActive LoopbackNone = False
isTrafficLoopbackActive _            = True

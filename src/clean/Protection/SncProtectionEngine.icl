
implementation module Etalon.Protection.SncProtectionEngine

import StdEnv
import Etalon.Protection.SncProtectionEngine
import Etalon.Types.Base

evaluateSncSwitch :: !SncState -> SncState
evaluateSncSwitch st
    | not st.isWorkingOk && st.isProtectOk = { st & activeIsWorking = False }
    | st.isWorkingOk = { st & activeIsWorking = True }
    = st

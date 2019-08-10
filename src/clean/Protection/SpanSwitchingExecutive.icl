
implementation module Etalon.Protection.SpanSwitchingExecutive

import StdEnv
import Etalon.Protection.SpanSwitchingExecutive
import Etalon.Types.Base

executeSpanSwitch :: !SpanSwitchState -> SpanSwitchState
executeSpanSwitch st =
    { st & isSwitchedToBackup = True }

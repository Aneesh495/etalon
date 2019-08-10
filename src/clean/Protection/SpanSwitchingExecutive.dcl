
definition module Etalon.Protection.SpanSwitchingExecutive

import StdEnv
import Etalon.Types.Base

:: SpanSwitchState = {
    spanId          :: !Int,
    backupFiberId   :: !Int,
    isSwitchedToBackup:: !Bool
}

executeSpanSwitch :: !SpanSwitchState -> SpanSwitchState

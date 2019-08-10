
definition module Etalon.Protection.FourFiberBshrRing

import StdEnv
import Etalon.Types.Base

:: BshrSwitchAction =
    BshrNoSwitch
  | BshrSpanSwitch !Int
  | BshrRingSwitch !Int

evaluateBshrFault :: !Int !Bool !Bool -> BshrSwitchAction

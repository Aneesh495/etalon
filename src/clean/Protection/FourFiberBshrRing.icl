
implementation module Etalon.Protection.FourFiberBshrRing

import StdEnv
import Etalon.Protection.FourFiberBshrRing
import Etalon.Types.Base

evaluateBshrFault :: !Int !Bool !Bool -> BshrSwitchAction
evaluateBshrFault spanId workingFailed protectFailed
    | workingFailed && not protectFailed = BshrSpanSwitch spanId
    | workingFailed && protectFailed     = BshrRingSwitch spanId
    = BshrNoSwitch

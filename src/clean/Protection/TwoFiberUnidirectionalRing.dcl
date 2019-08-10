
definition module Etalon.Protection.TwoFiberUnidirectionalRing

import StdEnv
import Etalon.Types.Base

:: UshrBridgeState = {
    ringId       :: !Int,
    isBridged    :: !Bool,
    switchTimeMs :: !Real
}

createUshrRing :: !Int -> UshrBridgeState

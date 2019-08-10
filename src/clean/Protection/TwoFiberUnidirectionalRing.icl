
implementation module Etalon.Protection.TwoFiberUnidirectionalRing

import StdEnv
import Etalon.Protection.TwoFiberUnidirectionalRing
import Etalon.Types.Base

createUshrRing :: !Int -> UshrBridgeState
createUshrRing rId = {
    ringId       = rId,
    isBridged    = False,
    switchTimeMs = 0.0
 }

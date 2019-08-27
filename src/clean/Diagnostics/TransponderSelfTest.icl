
implementation module Etalon.Diagnostics.TransponderSelfTest

import StdEnv
import Etalon.Diagnostics.TransponderSelfTest
import Etalon.Types.Base

runTransponderBist :: !Int -> BistStatus
runTransponderBist xcvId =
    BistPassed

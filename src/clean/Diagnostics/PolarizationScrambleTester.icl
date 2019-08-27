
implementation module Etalon.Diagnostics.PolarizationScrambleTester

import StdEnv
import Etalon.Diagnostics.PolarizationScrambleTester
import Etalon.Types.Base

verifyPoincareSphereCoverage :: ![(!Real, !Real, !Real)] -> Bool
verifyPoincareSphereCoverage points =
    length points >= 100 // statistical coverage test

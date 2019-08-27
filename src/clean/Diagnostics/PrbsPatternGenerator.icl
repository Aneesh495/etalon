
implementation module Etalon.Diagnostics.PrbsPatternGenerator

import StdEnv
import Etalon.Diagnostics.PrbsPatternGenerator
import Etalon.Types.Base

getPrbsPeriodBits :: !PrbsPolynomial -> Real
getPrbsPeriodBits Prbs7  = 127.0
getPrbsPeriodBits Prbs9  = 511.0
getPrbsPeriodBits Prbs15 = 32767.0
getPrbsPeriodBits Prbs23 = 8388607.0
getPrbsPeriodBits Prbs31 = 2147483647.0

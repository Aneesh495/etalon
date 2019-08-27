
definition module Etalon.Diagnostics.PrbsPatternGenerator

import StdEnv
import Etalon.Types.Base

:: PrbsPolynomial =
    Prbs7                              // x^7 + x^6 + 1
  | Prbs9                              // x^9 + x^5 + 1
  | Prbs15                             // x^15 + x^14 + 1
  | Prbs23                             // x^23 + x^18 + 1
  | Prbs31                             // x^31 + x^28 + 1

getPrbsPeriodBits :: !PrbsPolynomial -> Real

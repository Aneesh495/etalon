
implementation module Etalon.Security.QkdKeyDistributionSync

import StdEnv
import Etalon.Security.QkdKeyDistributionSync
import Etalon.Types.Base

isQkdSecure :: !QkdSession -> Bool
isQkdSecure sess =
    // Quantum bit error rate QBER must remain below 11% for unconditional security
    sess.qberPercent < 11.0

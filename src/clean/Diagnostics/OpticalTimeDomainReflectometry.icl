
implementation module Etalon.Diagnostics.OpticalTimeDomainReflectometry

import StdEnv
import Etalon.Diagnostics.OpticalTimeDomainReflectometry
import Etalon.Types.Base

detectOtdrEvents :: ![(!Real, !Real)] -> [OtdrEvent]
detectOtdrEvents trace =
    [{ locationKm = km, eventLossDb = loss, isReflective = loss > 0.5 } \ (km, loss) <- trace | loss >= 0.1]


definition module Etalon.Diagnostics.OpticalTimeDomainReflectometry

import StdEnv
import Etalon.Types.Base

:: OtdrEvent = {
    locationKm     :: !Real,
    eventLossDb    :: !Real,
    isReflective   :: !Bool
}

detectOtdrEvents :: ![(!Real, !Real)] -> [OtdrEvent]

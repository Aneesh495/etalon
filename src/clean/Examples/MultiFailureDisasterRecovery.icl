
implementation module Etalon.Examples.MultiFailureDisasterRecovery

import StdEnv
import Etalon.Examples.MultiFailureDisasterRecovery
import Etalon.Protection.MultiFailureResilience

runDisasterRecoveryDemo :: Bool
runDisasterRecoveryDemo =
    let s = { serviceId = 1, tier = TierGoldPremium, activeLightpathId = 101, isPreempted = False }
        restored = prioritizeRestoration [s]
    in length restored == 1

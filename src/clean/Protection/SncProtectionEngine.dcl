
definition module Etalon.Protection.SncProtectionEngine

import StdEnv
import Etalon.Types.Base

:: SncProtectionType =
    SncInherentMonitoring             // SNC/I
  | SncNonIntrusiveMonitoring         // SNC/N
  | SncSubLayerMonitoring             // SNC/S

:: SncState = {
    protType    :: !SncProtectionType,
    isWorkingOk :: !Bool,
    isProtectOk :: !Bool,
    activeIsWorking :: !Bool
}

evaluateSncSwitch :: !SncState -> SncState

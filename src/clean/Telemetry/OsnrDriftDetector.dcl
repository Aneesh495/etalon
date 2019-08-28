
definition module Etalon.Telemetry.OsnrDriftDetector

import StdEnv
import Etalon.Types.Base

:: DriftStatus =
    DriftNormal
  | DriftWarning !Real
  | DriftCritical !Real

evaluateOsnrDrift :: !Real !Real !Real -> DriftStatus


implementation module Etalon.Telemetry.EdfaGainTiltMonitor

import StdEnv
import Etalon.Telemetry.EdfaGainTiltMonitor
import Etalon.Types.Base

computeSpectralGainTiltDb :: !Real !Real -> Real
computeSpectralGainTiltDb gain1530Db gain1560Db =
    gain1560Db - gain1530Db

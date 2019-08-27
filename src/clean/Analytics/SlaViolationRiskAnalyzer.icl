
implementation module Etalon.Analytics.SlaViolationRiskAnalyzer

import StdEnv
import Etalon.Analytics.SlaViolationRiskAnalyzer
import Etalon.Types.Base

calculateCircuitRiskScore :: !Real !Int !Real -> Real
calculateCircuitRiskScore pathLengthKm hopCount osnrMarginDb =
    let lengthFactor = pathLengthKm / 1000.0
        hopFactor = toReal hopCount * 0.5
        marginFactor = maxReal 0.1 (5.0 - osnrMarginDb)
    in lengthFactor + hopFactor + marginFactor

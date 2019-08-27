
implementation module Etalon.Analytics.CapacityExhaustionForecaster

import StdEnv
import Etalon.Analytics.CapacityExhaustionForecaster
import Etalon.Types.Base

estimateExhaustionMonths :: !Real !Real !Real -> Real
estimateExhaustionMonths currentUtilization monthlyGrowthRate maxCapacity =
    // Months = ln(maxCapacity / currentUtilization) / ln(1 + monthlyGrowthRate)
    let ratio = maxCapacity / maxReal currentUtilization 1.0
    in if (monthlyGrowthRate <= 0.0) 120.0 (log10 ratio / log10 (1.0 + monthlyGrowthRate))

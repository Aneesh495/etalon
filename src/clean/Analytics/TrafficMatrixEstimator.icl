
implementation module Etalon.Analytics.TrafficMatrixEstimator

import StdEnv
import Etalon.Analytics.TrafficMatrixEstimator
import Etalon.Types.Base

estimateGravityDemandGbps :: !Real !Real !Real -> Real
estimateGravityDemandGbps originationGbps terminationGbps totalNetworkTrafficGbps =
    if (totalNetworkTrafficGbps <= 0.0) 0.0 ((originationGbps * terminationGbps) / totalNetworkTrafficGbps)

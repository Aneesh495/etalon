
implementation module Etalon.Standards.G8251JitterSpecs

import StdEnv
import Etalon.Standards.G8251JitterSpecs
import Etalon.Types.Base

getMaxOutputJitterUi :: !Int -> Real
getMaxOutputJitterUi 100 = 0.30 // 0.30 UI peak-to-peak for 100G
getMaxOutputJitterUi _   = 0.15

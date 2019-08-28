
implementation module Etalon.Standards.Ieee8023OpticalSpecs

import StdEnv
import Etalon.Standards.Ieee8023OpticalSpecs
import Etalon.Types.Base

getReachDistanceKm :: !IeeeOpticalPmd -> Real
getReachDistanceKm Pmd100GBaseLR4 = 10.0
getReachDistanceKm Pmd400GBaseLR8 = 10.0
getReachDistanceKm Pmd400GBaseFR4 = 2.0

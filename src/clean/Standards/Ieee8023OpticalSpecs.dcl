
definition module Etalon.Standards.Ieee8023OpticalSpecs

import StdEnv
import Etalon.Types.Base

:: IeeeOpticalPmd =
    Pmd100GBaseLR4
  | Pmd400GBaseLR8
  | Pmd400GBaseFR4

getReachDistanceKm :: !IeeeOpticalPmd -> Real

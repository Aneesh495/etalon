
implementation module Etalon.Protection.Client1Plus1Protection

import StdEnv
import Etalon.Protection.Client1Plus1Protection
import Etalon.Types.Base

switchClientToBackup :: !ClientProtPair -> ClientProtPair
switchClientToBackup pair =
    { pair & activePortId = pair.backupPortId }

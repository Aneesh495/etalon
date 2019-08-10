
definition module Etalon.Protection.Client1Plus1Protection

import StdEnv
import Etalon.Types.Base

:: ClientProtPair = {
    clientId      :: !Int,
    primaryPortId :: !Int,
    backupPortId  :: !Int,
    activePortId  :: !Int
}

switchClientToBackup :: !ClientProtPair -> ClientProtPair

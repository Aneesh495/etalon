
definition module Etalon.Security.OtnLayer1Encryption

import StdEnv
import Etalon.Types.Base

:: EncryptionAlgorithm =
    Aes256Gcm
  | Aes128Gcm

isLayer1Encrypted :: !EncryptionAlgorithm -> Bool


implementation module Etalon.Diagnostics.BertErrorInjector

import StdEnv
import Etalon.Diagnostics.BertErrorInjector
import Etalon.Types.Base

injectErrorsInBlock :: ![Int] !Int -> [Int]
injectErrorsInBlock bytes bitErrorsCount =
    case bytes of
        []      -> []
        [b:bs]  -> [b bitxor 0x01: bs] // flip first bit

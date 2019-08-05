implementation module Etalon.Otn.TcmProtectionCoordinator

/*
 * TcmProtectionCoordinator.icl: TCM coordinator implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.TcmProtectionCoordinator
import Etalon.Types.Base

createTcmCoordinator :: *TcmCoordinator
createTcmCoordinator = {
    levels           = [{ levelIndex = i, isActive = False, bip8ErrorsCount = 0, bdiDefectActive = False, operatorDomain = "" } \ i <- [1..6]],
    activeLevelCount = 0
 }

enableTcmLevel :: !*TcmCoordinator !Int !String -> *TcmCoordinator
enableTcmLevel coord=:{levels, activeLevelCount} lvl domain =
    let updated = [if (l.levelIndex == lvl) { l & isActive = True, operatorDomain = domain } l \ l <- levels]
    in { coord & levels = updated, activeLevelCount = activeLevelCount + 1 }

recordTcmErrors :: !*TcmCoordinator !Int !Int !Bool -> *TcmCoordinator
recordTcmErrors coord=:{levels} lvl errCount bdi =
    let updated = [if (l.levelIndex == lvl) { l & bip8ErrorsCount = errCount, bdiDefectActive = bdi } l \ l <- levels]
    in { coord & levels = updated }

hasTcmDefect :: !TcmCoordinator !Int -> Bool
hasTcmDefect coord lvl =
    case [l \ l <- coord.levels | l.levelIndex == lvl] of
        []    -> False
        [l:_] -> l.isActive && (l.bdiDefectActive || l.bip8ErrorsCount > 8)

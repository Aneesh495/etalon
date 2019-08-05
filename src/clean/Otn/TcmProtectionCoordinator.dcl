definition module Etalon.Otn.TcmProtectionCoordinator

/*
 * TcmProtectionCoordinator.dcl: Tandem Connection Monitoring (TCM1..TCM6).
 *
 * Implements ITU-T G.709 Section 15.8 multi-operator nested domain monitoring:
 *   - Sub-network connection protection (SNCP) triggers
 *   - TCM BIP-8, BEI, and BDI defect status per level
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: TcmLevelStatus = {
    levelIndex         :: !Int,        // 1..6
    isActive           :: !Bool,
    bip8ErrorsCount    :: !Int,
    bdiDefectActive    :: !Bool,
    operatorDomain     :: !String
}

:: *TcmCoordinator = {
    levels             :: ![TcmLevelStatus],
    activeLevelCount   :: !Int
}

createTcmCoordinator  :: *TcmCoordinator
enableTcmLevel        :: !*TcmCoordinator !Int !String -> *TcmCoordinator
recordTcmErrors       :: !*TcmCoordinator !Int !Int !Bool -> *TcmCoordinator
hasTcmDefect          :: !TcmCoordinator !Int -> Bool

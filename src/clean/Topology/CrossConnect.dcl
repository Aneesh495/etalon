definition module Etalon.Topology.CrossConnect

/*
 * CrossConnect.dcl: High-speed ROADM WSS Cross-Connect Switching Matrix.
 *
 * Implements non-blocking optical switching matrices routing flexible grid slices
 * between input ports (express/add) and output ports (express/drop).
 *
 * Uses uniqueness typing (*CrossConnectMatrix) for destructive in-place switching.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum

:: CrossConnectRule = {
    ruleId             :: !Int,
    inPort             :: !Int,
    outPort            :: !Int,
    startSlice         :: !Int,
    sliceCount         :: !Int,
    attenuationDb      :: !Real,
    enabled            :: !Bool
}

:: *CrossConnectMatrix = {
    matrixNodeId       :: !Int,
    rules              :: ![CrossConnectRule],
    ruleCount          :: !Int
}

// Lifecycle and constructors
createCrossConnectMatrix :: !Int -> *CrossConnectMatrix
cloneCrossConnectMatrix  :: !CrossConnectMatrix -> CrossConnectMatrix

// In-place cross-connect modification using uniqueness typing
addCrossConnect          :: !*CrossConnectMatrix !Int !Int !Int !Int !Real -> *CrossConnectMatrix
removeCrossConnect       :: !*CrossConnectMatrix !Int -> *CrossConnectMatrix
updateEgressPort         :: !*CrossConnectMatrix !Int !Int -> *CrossConnectMatrix
setCrossConnectAttenuation :: !*CrossConnectMatrix !Int !Real -> *CrossConnectMatrix

// Queries
findRuleForSlice         :: !CrossConnectMatrix !Int !Int -> CrossConnectRule
isRuleActive             :: !CrossConnectMatrix !Int -> Bool
countActiveConnections   :: !CrossConnectMatrix -> Int

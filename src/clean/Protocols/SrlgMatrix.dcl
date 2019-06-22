definition module Etalon.Protocols.SrlgMatrix

/*
 * SrlgMatrix.dcl: Shared Risk Link Group (SRLG) collision engine.
 *
 * Models shared physical conduit, rights-of-way, bridge crossings,
 * and undersea fiber cables across the carrier topology.
 *
 * Provides disjoint path verification under complex multi-SRLG memberships.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: SrlgRiskCategory =
    SrlgConduitMetro
  | SrlgBridgeCrossing
  | SrlgSubseaTrench
  | SrlgPowerSubstation
  | SrlgAerialPylon

:: SrlgGroup = {
    srlgId            :: !Int,
    category          :: !SrlgRiskCategory,
    description       :: !String,
    memberLinkIds     :: ![Int],
    riskWeight        :: !Real
}

:: SrlgMatrix = {
    groups            :: ![SrlgGroup],
    linkToSrlgMap     :: ![(!Int, ![Int])],
    totalGroups       :: !Int
}

createSrlgMatrix        :: *SrlgMatrix
registerSrlgGroup       :: !*SrlgMatrix !Int !SrlgRiskCategory !String ![Int] !Real -> *SrlgMatrix
getLinkSrlgs            :: !SrlgMatrix !Int -> [Int]
arePathsSrlgDisjoint    :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Bool
computeSrlgOverlapRisk  :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Real
findCommonSrlgs         :: !SrlgMatrix !OpticalRoute !OpticalRoute -> [Int]

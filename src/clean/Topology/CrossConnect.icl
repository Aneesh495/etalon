implementation module Etalon.Topology.CrossConnect

/*
 * CrossConnect.icl: Implementation of non-blocking optical cross-connect switching.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.CrossConnect

createCrossConnectMatrix :: !Int -> *CrossConnectMatrix
createCrossConnectMatrix nId = {
    matrixNodeId = nId,
    rules        = [],
    ruleCount    = 0
}

cloneCrossConnectMatrix :: !CrossConnectMatrix -> CrossConnectMatrix
cloneCrossConnectMatrix m = {
    matrixNodeId = m.matrixNodeId,
    rules        = [r \\ r <- m.rules],
    ruleCount    = m.ruleCount
}

addCrossConnect :: !*CrossConnectMatrix !Int !Int !Int !Int !Real -> *CrossConnectMatrix
addCrossConnect m=:{rules,ruleCount} inP outP start len attDb =
    let newRule = {
            ruleId        = ruleCount + 1,
            inPort        = inP,
            outPort       = outP,
            startSlice    = start,
            sliceCount    = len,
            attenuationDb = attDb,
            enabled       = True
        }
    in { m & rules = rules ++ [newRule], ruleCount = ruleCount + 1 }

removeCrossConnect :: !*CrossConnectMatrix !Int -> *CrossConnectMatrix
removeCrossConnect m=:{rules,ruleCount} targetRuleId =
    let updatedRules = [r \\ r <- rules | r.ruleId <> targetRuleId]
    in { m & rules = updatedRules, ruleCount = length updatedRules }

updateEgressPort :: !*CrossConnectMatrix !Int !Int -> *CrossConnectMatrix
updateEgressPort m=:{rules} targetRuleId newOutPort =
    let updatedRules = [{ r & outPort = if (r.ruleId == targetRuleId) newOutPort r.outPort } \\ r <- rules]
    in { m & rules = updatedRules }

setCrossConnectAttenuation :: !*CrossConnectMatrix !Int !Real -> *CrossConnectMatrix
setCrossConnectAttenuation m=:{rules} targetRuleId newAttDb =
    let updatedRules = [{ r & attenuationDb = if (r.ruleId == targetRuleId) newAttDb r.attenuationDb } \\ r <- rules]
    in { m & rules = updatedRules }

findRuleForSlice :: !CrossConnectMatrix !Int !Int -> CrossConnectRule
findRuleForSlice m inP slice =
    searchRules m.rules
where
    searchRules [] = {
        ruleId        = 0,
        inPort        = inP,
        outPort       = 0,
        startSlice    = 0,
        sliceCount    = 0,
        attenuationDb = 0.0,
        enabled       = False
    }
    searchRules [r:rs]
        | r.inPort == inP && slice >= r.startSlice && slice < (r.startSlice + r.sliceCount) && r.enabled = r
        = searchRules rs

isRuleActive :: !CrossConnectMatrix !Int -> Bool
isRuleActive m targetRuleId =
    any (\r -> r.ruleId == targetRuleId && r.enabled) m.rules

countActiveConnections :: !CrossConnectMatrix -> Int
countActiveConnections m =
    sum [1 \\ r <- m.rules | r.enabled]

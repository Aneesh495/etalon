implementation module Etalon.Topology.MultiDomainTopology

/*
 * MultiDomainTopology.icl: Multi-domain topology implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.MultiDomainTopology
import Etalon.Types.Base

createOpticalDomain :: !Int !String ![Int] !Int -> OpticalDomain
createOpticalDomain dId name borders count = {
    domainId          = dId,
    domainName        = name,
    borderNodeIds     = borders,
    internalNodeCount = count
 }

createInterDomainLink :: !Int !Int !Int !Int !Int !Real -> InterDomainLink
createInterDomainLink lId srcD srcN dstD dstN len = {
    idlId              = lId,
    sourceDomainId     = srcD,
    sourceBorderNodeId = srcN,
    destDomainId       = dstD,
    destBorderNodeId   = dstN,
    lengthKm           = len
 }

definition module Etalon.Topology.MultiDomainTopology

/*
 * MultiDomainTopology.dcl: Inter-Domain Optical Routing (RFC 8453 ACTN).
 *
 * Models hierarchical multi-domain carrier architectures:
 *   - Multi-Domain Orchestrator (MDSC) abstract topology abstraction
 *   - Border ROADM nodes and Inter-Domain Optical Links (IDLs)
 *   - Optical Reachability Matrices across domain boundaries
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OpticalDomain = {
    domainId          :: !Int,
    domainName        :: !String,
    borderNodeIds     :: ![Int],
    internalNodeCount :: !Int
}

:: InterDomainLink = {
    idlId             :: !Int,
    sourceDomainId    :: !Int,
    sourceBorderNodeId:: !Int,
    destDomainId      :: !Int,
    destBorderNodeId  :: !Int,
    lengthKm          :: !Real
}

createOpticalDomain   :: !Int !String ![Int] !Int -> OpticalDomain
createInterDomainLink :: !Int !Int !Int !Int !Int !Real -> InterDomainLink

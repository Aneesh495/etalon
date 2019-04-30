definition module Etalon.Routing.ImpairmentAware

/*
 * ImpairmentAware.dcl: Impairment-Aware Routing and Wavelength Assignment (IA-RWA / IA-RSA).
 *
 * Jointly optimizes lightpath routing, spectrum allocation, and physical-layer
 * feasibility using the Gaussian Noise (GN) impairment model and Q-factor evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.Spectrum
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.GaussianNoise
import Etalon.Physical.QFactor
import Etalon.Topology.Graph
import Etalon.Topology.Path
import Etalon.Topology.NetworkState
import Etalon.Routing.KShortestPaths
import Etalon.Routing.SpectrumAssign

:: ServiceDemand = {
    demandId           :: !Int,
    ingressNodeId      :: !Int,
    egressNodeId       :: !Int,
    requestedBitrateGbps :: !Real,
    preferredFec       :: !FecType,
    requireProtection  :: !Bool
}

:: ProvisioningResult = {
    demandRef          :: !ServiceDemand,
    primaryLightpath   :: !Lightpath,
    backupLightpath    :: !?Lightpath,
    assessment         :: !ReachAssessment,
    isSuccessful       :: !Bool,
    rejectionReason    :: !String
}

// Main IA-RWA solver
solveIaRwaDemand       :: !*WorldState !ServiceDemand !Int !AllocationPolicy -> (*WorldState, ProvisioningResult)

// Batch provisioning
solveBatchDemands      :: !*WorldState ![ServiceDemand] !AllocationPolicy -> (*WorldState, [ProvisioningResult])

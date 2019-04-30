implementation module Etalon.Routing.ImpairmentAware

/*
 * ImpairmentAware.icl: Implementation of the joint IA-RWA solver.
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
import Etalon.Topology.CrossConnect
import Etalon.Topology.NetworkState
import Etalon.Routing.KShortestPaths
import Etalon.Routing.SpectrumAssign
import Etalon.Routing.ImpairmentAware

solveIaRwaDemand :: !*WorldState !ServiceDemand !Int !AllocationPolicy -> (*WorldState, ProvisioningResult)
solveIaRwaDemand state=:{topology} demand kCandidates policy =
    evalWithRoutes (findKShortestPaths topology demand.ingressNodeId demand.egressNodeId kCandidates) state
where
    evalWithRoutes [] curS = (curS, failResult "NO_ROUTE_FOUND")
    evalWithRoutes routes curS = evaluateRoutes curS routes
where
    failResult reason = {
        demandRef        = demand,
        primaryLightpath = createLightpath 0 demand.demandId (createRouteFromLinks 0 []) (createFrequencySlot 0 4) DpQpsk demand.preferredFec demand.requestedBitrateGbps,
        backupLightpath  = ?None,
        assessment       = assessLightpathReach 0.0 DpQpsk demand.preferredFec,
        isSuccessful     = False,
        rejectionReason  = reason
    }

    evaluateRoutes curS [] = (curS, failResult "PHYSICAL_REACH_OR_SPECTRUM_BLOCKED")
    evaluateRoutes curS [route:routes] =
        let estOsnrDb = estimateRouteOsnr curS route
            optimalMod = findBestModulationForSnr estOsnrDb demand.preferredFec
            reachCheck = assessLightpathReach estOsnrDb optimalMod demand.preferredFec
        in if (not reachCheck.isReachFeasible)
            (evaluateRoutes curS routes)
            (let slotWidthMult = computeSlotWidthReq demand.requestedBitrateGbps optimalMod
                 allocRes = assignSpectrumForRoute curS route slotWidthMult policy
             in if (not allocRes.success)
                (evaluateRoutes curS routes)
                (let primaryLp = createLightpath curS.nextServiceId demand.demandId route allocRes.allocatedSlot optimalMod demand.preferredFec demand.requestedBitrateGbps
                     primaryWithOsnr = { primaryLp & operatingOsnrDb = estOsnrDb }
                 in if (not demand.requireProtection)
                    (curS, {
                        demandRef        = demand,
                        primaryLightpath = primaryWithOsnr,
                        backupLightpath  = ?None,
                        assessment       = reachCheck,
                        isSuccessful     = True,
                        rejectionReason  = "NONE"
                    })
                    (solveBackupPath curS demand route allocRes.allocatedSlot optimalMod reachCheck primaryWithOsnr policy)))

    estimateRouteOsnr :: !WorldState !OpticalRoute -> Real
    estimateRouteOsnr s r =
        let numSpans = r.totalLengthKm / 80.0
            accumPenalty = numSpans * 0.5
        in maxReal (35.0 - accumPenalty) 10.0

    computeSlotWidthReq :: !Real !ModulationFormat -> Int
    computeSlotWidthReq bitrate mod =
        let se = spectralEfficiency mod
            opticalBwHz = (bitrate * 1.0e9) / se
            slots = (toReal opticalBwHz) / slotGranularityHz
        in max (toInt (ceil slots)) 2

    solveBackupPath :: !*WorldState !ServiceDemand !OpticalRoute !FrequencySlot !ModulationFormat !ReachAssessment !Lightpath !AllocationPolicy -> (*WorldState, ProvisioningResult)
    solveBackupPath s dem primaryRoute slot mod assessment primary policy =
        let (pRoute, bRoute) = findDisjointRoutePair s.topology dem.ingressNodeId dem.egressNodeId
        in if (isEmpty bRoute.linkSequence)
            (s, {
                demandRef        = dem,
                primaryLightpath = primary,
                backupLightpath  = ?None,
                assessment       = assessment,
                isSuccessful     = False,
                rejectionReason  = "DISJOINT_PROTECTION_UNAVAILABLE"
            })
            (let bSlotWidth = computeSlotWidthReq dem.requestedBitrateGbps mod
                 bAlloc = assignSpectrumForRoute s bRoute bSlotWidth policy
             in if (not bAlloc.success)
                (s, {
                    demandRef        = dem,
                    primaryLightpath = primary,
                    backupLightpath  = ?None,
                    assessment       = assessment,
                    isSuccessful     = False,
                    rejectionReason  = "BACKUP_SPECTRUM_BLOCKED"
                })
                (let backupLp = createLightpath (primary.pathId + 10000) dem.demandId bRoute bAlloc.allocatedSlot mod dem.preferredFec dem.requestedBitrateGbps
                     protectedPrimary = { primary & isProtected = True }
                 in (s, {
                    demandRef        = dem,
                    primaryLightpath = protectedPrimary,
                    backupLightpath  = ?Just backupLp,
                    assessment       = assessment,
                    isSuccessful     = True,
                    rejectionReason  = "NONE"
                 })))

solveBatchDemands :: !*WorldState ![ServiceDemand] !AllocationPolicy -> (*WorldState, [ProvisioningResult])
solveBatchDemands state demands policy =
    processDemands state demands []
where
    processDemands :: !*WorldState ![ServiceDemand] ![ProvisioningResult] -> (*WorldState, [ProvisioningResult])
    processDemands curState [] acc = (curState, reverse acc)
    processDemands curState [d:ds] acc =
        let (curState1, res) = solveIaRwaDemand curState d 5 policy
            nextState = if res.isSuccessful
                            (let s1 = provisionLightpath curState1 res.primaryLightpath
                             in case res.backupLightpath of
                                 ?Just bLp -> provisionLightpath s1 bLp
                                 ?None     -> s1)
                            curState1
        in processDemands nextState ds [res : acc]

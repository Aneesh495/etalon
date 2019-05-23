implementation module Etalon.Simulation.DiscreteEvent

/*
 * DiscreteEvent.icl: Implementation of the discrete event simulation engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.NetworkState
import Etalon.Routing.ImpairmentAware
import Etalon.Routing.SpectrumAssign
import Etalon.Simulation.TrafficGenerator
import Etalon.Simulation.DiscreteEvent

initSimulationState :: !WorldState -> *SimulationState
initSimulationState ws = {
    networkState = ws,
    eventQueue   = [],
    currentTime  = 0.0,
    metrics      = {
        totalOfferedDemands = 0,
        acceptedDemands     = 0,
        blockedDemands      = 0,
        blockingRatio       = 0.0,
        totalOfferedGbps    = 0.0,
        acceptedGbps        = 0.0,
        averageHoldTime     = 0.0
    }
}

enqueueEvent :: !*SimulationState !SimulationEvent -> *SimulationState
enqueueEvent state=:{eventQueue} ev =
    let updatedQueue = insertSorted eventQueue ev
    in { state & eventQueue = updatedQueue }
where
    insertSorted :: ![SimulationEvent] !SimulationEvent -> [SimulationEvent]
    insertSorted [] item = [item]
    insertSorted [x:xs] item
        | item.eventTime < x.eventTime = [item, x : xs]
        = [x : insertSorted xs item]

runSimulationUntilTime :: !*SimulationState !Real !AllocationPolicy -> (*SimulationState, SimulationMetrics)
runSimulationUntilTime state maxTime policy =
    simLoop state
where
    simLoop :: !*SimulationState -> (*SimulationState, SimulationMetrics)
    simLoop curState=:{eventQueue,currentTime,metrics}
        | isEmpty eventQueue = (curState, metrics)
        = let (ev:remQueue) = eventQueue
          in if (ev.eventTime > maxTime)
              (curState, metrics)
              (let s1 = { curState & eventQueue = remQueue, currentTime = ev.eventTime }
               in if ev.isArrival
                  (let (nextNet, res) = solveIaRwaDemand s1.networkState ev.demandPayload 5 policy
                       newMetrics = { metrics & totalOfferedDemands = metrics.totalOfferedDemands + 1,
                                                totalOfferedGbps = metrics.totalOfferedGbps + ev.demandPayload.requestedBitrateGbps }
                   in if res.isSuccessful
                      (let s2 = provisionLightpath nextNet res.primaryLightpath
                           depEvent = {
                               eventTime      = ev.eventTime + 3600.0, // 1 hour holding stub
                               isArrival      = False,
                               demandPayload  = ev.demandPayload,
                               teardownPathId = res.primaryLightpath.pathId
                           }
                           s3 = enqueueEvent { s1 & networkState = s2 } depEvent
                           mAcc = { newMetrics & acceptedDemands = newMetrics.acceptedDemands + 1,
                                                 acceptedGbps = newMetrics.acceptedGbps + ev.demandPayload.requestedBitrateGbps }
                       in simLoop { s3 & metrics = mAcc })
                      (let mBlock = { newMetrics & blockedDemands = newMetrics.blockedDemands + 1,
                                                   blockingRatio = (toReal (newMetrics.blockedDemands + 1)) / (toReal newMetrics.totalOfferedDemands) }
                       in simLoop { s1 & networkState = nextNet, metrics = mBlock }))
                  (let sTeardown = teardownLightpath s1.networkState ev.teardownPathId
                   in simLoop { s1 & networkState = sTeardown }))

formatMetricsReport :: !SimulationMetrics -> String
formatMetricsReport m =
    "Offered: " +++ (toString m.totalOfferedDemands) +++
    ", Accepted: " +++ (toString m.acceptedDemands) +++
    ", Blocked: " +++ (toString m.blockedDemands)

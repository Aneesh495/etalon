implementation module Etalon.Otn.OduFlexRateAdaptation

/*
 * OduFlexRateAdaptation.icl: ODUflex HAO implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.OduFlexRateAdaptation

initOduFlexChannel :: !Int !Int -> OduFlexChannel
initOduFlexChannel id initialSlots =
    { oduId                 = id
    , currentTributarySlots = initialSlots
    , targetTributarySlots  = initialSlots
    , state                 = HaoIdle
    }

requestBandwidthChange :: !OduFlexChannel !Int -> OduFlexChannel
requestBandwidthChange ch newSlots =
    let nextState = if (newSlots > ch.currentTributarySlots) HaoBwIncreaseReq HaoBwDecreaseReq
    in { ch & targetTributarySlots = newSlots, state = nextState }

processHaoAck :: !OduFlexChannel -> OduFlexChannel
processHaoAck ch =
    { ch & currentTributarySlots = ch.targetTributarySlots, state = HaoCompleted }

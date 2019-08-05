definition module Etalon.Otn.OduFlexRateAdaptation

/*
 * OduFlexRateAdaptation.dcl: ODUflex hitless resizing (HAO) protocol engine per ITU-T G.7044.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: HaoState = HaoIdle | HaoBwIncreaseReq | HaoBwDecreaseReq | HaoAckReceived | HaoCompleted

:: OduFlexChannel =
    { oduId              :: !Int
    , currentTributarySlots :: !Int
    , targetTributarySlots  :: !Int
    , state              :: !HaoState
    }

initOduFlexChannel :: !Int !Int -> OduFlexChannel
requestBandwidthChange :: !OduFlexChannel !Int -> OduFlexChannel
processHaoAck :: !OduFlexChannel -> OduFlexChannel

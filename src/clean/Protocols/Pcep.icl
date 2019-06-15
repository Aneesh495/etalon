implementation module Etalon.Protocols.Pcep

/*
 * Pcep.icl: Path Computation Element Protocol implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.Pcep
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path

createPcepSession :: !Int !String !Int -> *PcepSession
createPcepSession sessId peer keepalive = {
    sessionId          = sessId,
    peerAddress        = peer,
    keepaliveTimerSec  = keepalive,
    deadTimerSec       = keepalive * 4,
    nextRequestId      = 1,
    activeLspCount     = 0,
    receivedMessages   = [],
    txSequenceNumber   = 0
 }

buildOpenMessage :: !Int !Int -> PcepMessage
buildOpenMessage sessId keepalive = {
    msgType            = PcepOpenMsg,
    requestId          = 0,
    sourceNodeId       = 0,
    targetNodeId       = 0,
    bandwidthGbps      = 0.0,
    eroList            = [],
    plspState          = ?None,
    timestampSec       = 0.0
 }

buildKeepaliveMessage :: PcepMessage
buildKeepaliveMessage = {
    msgType            = PcepKeepaliveMsg,
    requestId          = 0,
    sourceNodeId       = 0,
    targetNodeId       = 0,
    bandwidthGbps      = 0.0,
    eroList            = [],
    plspState          = ?None,
    timestampSec       = 0.0
 }

buildPathRequest :: !Int !Int !Int !Real -> PcepMessage
buildPathRequest reqId src dst bw = {
    msgType            = PcepReqMsg,
    requestId          = reqId,
    sourceNodeId       = src,
    targetNodeId       = dst,
    bandwidthGbps      = bw,
    eroList            = [],
    plspState          = ?None,
    timestampSec       = 0.0
 }

buildPathReport :: !Int !PcepPlspId !OpticalRoute !FrequencySlot -> PcepMessage
buildPathReport reqId plsp route slot =
    let wsonTlv = {
            gridType           = 1,
            channelSpacingGhz  = 6.25,
            nominalCenterFreqM = slot.centerFreqM,
            slotWidthM         = slot.slotWidthM
        }
        ero = [EroWsonSpectrum wsonTlv: [EroUnnumberedLink lId 0 \ lId <- route.linkSequence]]
    in {
        msgType            = PcepReportMsg,
        requestId          = reqId,
        sourceNodeId       = route.sourceNodeId,
        targetNodeId       = route.destinationNodeId,
        bandwidthGbps      = 100.0,
        eroList            = ero,
        plspState          = ?Just plsp,
        timestampSec       = 0.0
    }

buildInitiateMessage :: !Int !Int !Int !Real !OpticalRoute !FrequencySlot -> PcepMessage
buildInitiateMessage reqId src dst bw route slot =
    let wsonTlv = {
            gridType           = 1,
            channelSpacingGhz  = 6.25,
            nominalCenterFreqM = slot.centerFreqM,
            slotWidthM         = slot.slotWidthM
        }
        ero = [EroWsonSpectrum wsonTlv: [EroUnnumberedLink lId 0 \ lId <- route.linkSequence]]
        plsp = {
            plspId        = reqId,
            tunnelId      = 100 + reqId,
            lspId         = 1,
            isDelegated   = True,
            isOperational = True
        }
    in {
        msgType            = PcepInitiateMsg,
        requestId          = reqId,
        sourceNodeId       = src,
        targetNodeId       = dst,
        bandwidthGbps      = bw,
        eroList            = ero,
        plspState          = ?Just plsp,
        timestampSec       = 0.0
    }

processIncomingMessage :: !*PcepSession !PcepMessage -> *PcepSession
processIncomingMessage session=:{receivedMessages, activeLspCount, txSequenceNumber} msg =
    let newHistory = [msg: receivedMessages]
        deltaLsp = case msg.msgType of
            PcepInitiateMsg -> 1
            PcepReportMsg   -> 1
            _               -> 0
    in { session &
        receivedMessages = newHistory,
        activeLspCount   = activeLspCount + deltaLsp,
        txSequenceNumber = txSequenceNumber + 1
    }

pcepMessageTypeToString :: !PcepMessageType -> String
pcepMessageTypeToString PcepOpenMsg        = "OPEN"
pcepMessageTypeToString PcepKeepaliveMsg   = "KEEPALIVE"
pcepMessageTypeToString PcepReqMsg         = "PCREQ"
pcepMessageTypeToString PcepRepMsg         = "PCREP"
pcepMessageTypeToString PcepReportMsg      = "PCRPT"
pcepMessageTypeToString PcepInitiateMsg    = "PCINITIATE"
pcepMessageTypeToString (PcepErrorMsg c t) = "PCERR"

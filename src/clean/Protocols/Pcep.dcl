definition module Etalon.Protocols.Pcep

/*
 * Pcep.dcl: Path Computation Element Communication Protocol (PCEP).
 *
 * Implements message framing, stateful PCE extensions (RFC 8231),
 * initiation (RFC 8281), and WSON/flex-grid extensions (RFC 8779).
 *
 * Uniqueness typing (*PcepSession) ensures lock-free session state serialization.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path

// PCEP Message Types (RFC 5440 / RFC 8231 / RFC 8281)
pcepMsgOpen         :== 1
pcepMsgKeepalive    :== 2
pcepMsgPCReq        :== 3
pcepMsgPCRep        :== 4
pcepMsgPCNtf        :== 5
pcepMsgPCErr        :== 6
pcepMsgClose        :== 7
pcepMsgReport       :== 10
pcepMsgUpdate       :== 11
pcepMsgInitiate     :== 12

// PCEP Object Classes
pcepObjOpen         :== 1
pcepObjRp           :== 2
pcepObjNoPath       :== 3
pcepObjEndpoints    :== 4
pcepObjBandwidth    :== 5
pcepObjMetric       :== 6
pcepObjEro          :== 7
pcepObjRro          :== 8
pcepObjLspa         :== 9
pcepObjIro          :== 10
pcepObjSrp          :== 33
pcepObjLsp          :== 32
pcepObjWson         :== 42

:: PcepMessageType =
    PcepOpenMsg
  | PcepKeepaliveMsg
  | PcepReqMsg
  | PcepRepMsg
  | PcepReportMsg
  | PcepInitiateMsg
  | PcepErrorMsg !Int !Int

:: PcepPlspId = {
    plspId             :: !Int,
    tunnelId           :: !Int,
    lspId              :: !Int,
    isDelegated        :: !Bool,
    isOperational      :: !Bool
}

:: PcepWsonTlv = {
    gridType           :: !Int,        // 1 = ITU-T FlexGrid
    channelSpacingGhz  :: !Real,       // 6.25 GHz, 12.5 GHz
    nominalCenterFreqM :: !Int,        // Frequency slot multiplier n
    slotWidthM         :: !Int         // Slot width multiplier m
}

:: PcepEroSubobject =
    EroIpv4Prefix !String !Int
  | EroUnnumberedLink !Int !Int
  | EroWsonSpectrum !PcepWsonTlv

:: PcepMessage = {
    msgType            :: !PcepMessageType,
    requestId          :: !Int,
    sourceNodeId       :: !Int,
    targetNodeId       :: !Int,
    bandwidthGbps      :: !Real,
    eroList            :: ![PcepEroSubobject],
    plspState          :: !?PcepPlspId,
    timestampSec       :: !Real
}

:: *PcepSession = {
    sessionId          :: !Int,
    peerAddress        :: !String,
    keepaliveTimerSec  :: !Int,
    deadTimerSec       :: !Int,
    nextRequestId      :: !Int,
    activeLspCount     :: !Int,
    receivedMessages   :: ![PcepMessage],
    txSequenceNumber   :: !Int
}

// Session lifecycle and message builders
createPcepSession     :: !Int !String !Int -> *PcepSession
buildOpenMessage      :: !Int !Int -> PcepMessage
buildKeepaliveMessage :: PcepMessage
buildPathRequest      :: !Int !Int !Int !Real -> PcepMessage
buildPathReport       :: !Int !PcepPlspId !OpticalRoute !FrequencySlot -> PcepMessage
buildInitiateMessage  :: !Int !Int !Int !Real !OpticalRoute !FrequencySlot -> PcepMessage

// Message parsing and dispatch
processIncomingMessage:: !*PcepSession !PcepMessage -> *PcepSession
pcepMessageTypeToString:: !PcepMessageType -> String

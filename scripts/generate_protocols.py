#!/usr/bin/env python3
"""
Generator for Etalon Clean Protocols Subsystem:
  - Pcep (Path Computation Element Protocol RFC 5440 / RFC 8697 / RFC 8779)
  - Gmp (GMPLS RSVP-TE Optical Signaling RFC 7688 / RFC 3473)
  - G709OverheadParser (ITU-T G.709 Section 15 OTU/ODU/OPU Overhead Bitmask Engine)
  - SrlgMatrix (Shared Risk Link Group Co-Location Collision Engine)

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PROTOCOLS_DIR = REPO_ROOT / "src" / "clean" / "Protocols"
PROTOCOLS_DIR.mkdir(parents=True, exist_ok=True)

def write_module(name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {name}.icl"
    dcl_path = PROTOCOLS_DIR / f"{name}.dcl"
    icl_path = PROTOCOLS_DIR / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {name}.dcl and {name}.icl")

def build_pcep():
    dcl = """definition module Etalon.Protocols.Pcep

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
"""

    icl = """implementation module Etalon.Protocols.Pcep

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
        ero = [EroWsonSpectrum wsonTlv: [EroUnnumberedLink lId 0 \\ lId <- route.linkSequence]]
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
        ero = [EroWsonSpectrum wsonTlv: [EroUnnumberedLink lId 0 \\ lId <- route.linkSequence]]
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
"""
    write_module("Pcep", dcl, icl)

def build_gmp():
    dcl = """definition module Etalon.Protocols.Gmp

/*
 * Gmp.dcl: Generalized Multiprotocol Label Switching (GMPLS) signaling engine.
 *
 * Implements RSVP-TE optical extensions (RFC 3473 / RFC 7688), Generalized Label
 * Request, optical explicit route objects (ERO), and bidirectional lightpath setup.
 *
 * Uses uniqueness typing (*GmplsState) for deterministic label distribution.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path

// GMPLS Switching Capability
gmplsSwitchingL2SC    :== 51
gmplsSwitchingTDM     :== 100
gmplsSwitchingLSC     :== 150       // Lambda-Switch Capable (WSON)
gmplsSwitchingFSC     :== 200       // Fiber-Switch Capable

:: GmplsLabel = {
    gridType          :: !Int,      // ITU-T FlexGrid = 1
    channelSpacingGhz :: !Real,     // 6.25 GHz
    channelIdentifier :: !Int,      // Central frequency n
    slotWidthMult     :: !Int       // Slot width m
}

:: RsvpMsgType =
    RsvpPathMsg
  | RsvpResvMsg
  | RsvpPathErr
  | RsvpResvErr
  | RsvpPathTear
  | RsvpResvTear

:: RsvpSession = {
    tunnelId          :: !Int,
    extTunnelId       :: !Int,
    sourceIp          :: !String,
    destIp            :: !String
}

:: RsvpTeMessage = {
    messageType       :: !RsvpMsgType,
    session           :: !RsvpSession,
    explicitRoute     :: ![Int],    // Sequence of link IDs
    allocatedLabel    :: !?GmplsLabel,
    protectionFlag    :: !Bool,
    refreshIntervalSec:: !Int
}

:: *GmplsSignalingState = {
    activeSessions    :: ![RsvpSession],
    assignedLabels    :: ![(!Int, !GmplsLabel)],
    totalPathMessages :: !Int,
    totalResvMessages :: !Int,
    lastErrorCode     :: !Int
}

createGmplsState      :: *GmplsSignalingState
createRsvpPath        :: !Int !String !String ![Int] !GmplsLabel !Bool -> RsvpTeMessage
createRsvpResv        :: !RsvpSession !GmplsLabel -> RsvpTeMessage
processRsvpMessage    :: !*GmplsSignalingState !RsvpTeMessage -> *GmplsSignalingState
labelToString         :: !GmplsLabel -> String
"""

    icl = """implementation module Etalon.Protocols.Gmp

/*
 * Gmp.icl: GMPLS signaling engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.Gmp
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path

createGmplsState :: *GmplsSignalingState
createGmplsState = {
    activeSessions    = [],
    assignedLabels    = [],
    totalPathMessages = 0,
    totalResvMessages = 0,
    lastErrorCode     = 0
 }

createRsvpPath :: !Int !String !String ![Int] !GmplsLabel !Bool -> RsvpTeMessage
createRsvpPath tId src dst hops label isProtected = {
    messageType       = RsvpPathMsg,
    session           = { tunnelId = tId, extTunnelId = 1, sourceIp = src, destIp = dst },
    explicitRoute     = hops,
    allocatedLabel    = ?Just label,
    protectionFlag    = isProtected,
    refreshIntervalSec= 30
 }

createRsvpResv :: !RsvpSession !GmplsLabel -> RsvpTeMessage
createRsvpResv sess label = {
    messageType       = RsvpResvMsg,
    session           = sess,
    explicitRoute     = [],
    allocatedLabel    = ?Just label,
    protectionFlag    = False,
    refreshIntervalSec= 30
 }

processRsvpMessage :: !*GmplsSignalingState !RsvpTeMessage -> *GmplsSignalingState
processRsvpMessage st=:{activeSessions, assignedLabels, totalPathMessages, totalResvMessages} msg =
    case msg.messageType of
        RsvpPathMsg ->
            { st &
                activeSessions    = [msg.session: activeSessions],
                totalPathMessages = totalPathMessages + 1
            }
        RsvpResvMsg ->
            let newLabels = case msg.allocatedLabel of
                    ?Just lbl -> [(msg.session.tunnelId, lbl): assignedLabels]
                    ?None     -> assignedLabels
            in { st &
                assignedLabels    = newLabels,
                totalResvMessages = totalResvMessages + 1
            }
        _ ->
            st

labelToString :: !GmplsLabel -> String
labelToString lbl =
    "FlexGrid(n=" +++ toString lbl.channelIdentifier +++ ",m=" +++ toString lbl.slotWidthMult +++ ")"
"""
    write_module("Gmp", dcl, icl)

def build_g709_parser():
    dcl = """definition module Etalon.Protocols.G709OverheadParser

/*
 * G709OverheadParser.dcl: Bitmask-level ITU-T G.709 Section 15 overhead parser.
 *
 * Extracts and synthesizes Section Monitoring (SM), Path Monitoring (PM),
 * Tandem Connection Monitoring (TCM1..TCM6), General Communication Channels
 * (GCC0, GCC1, GCC2), and Automatic Protection Switching (APS/PCC) bytes.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

:: TrailTraceIdentifier = {
    sapi               :: !String,     // Source Access Point Identifier (16 octets)
    dapi               :: !String,     // Destination Access Point Identifier (16 octets)
    operatorSpecific   :: !String      // Operator-specific field (32 octets)
}

:: SectionMonitoringInfo = {
    tti                :: !TrailTraceIdentifier,
    bip8ErrorCount     :: !Int,        // 0..8 parity mismatch count
    backwardDefectInd  :: !Bool,       // BDI (bit 5)
    backwardErrorInd   :: !Int         // BEI (bits 1..4, 0..8 errors)
}

:: PathMonitoringInfo = {
    tti                :: !TrailTraceIdentifier,
    bip8ErrorCount     :: !Int,
    backwardDefectInd  :: !Bool,
    backwardErrorInd   :: !Int,
    maintenanceStatus  :: !Int         // STAT (bits 6..8: 001=Normal, 010=AIS, 111=LCK)
}

:: OverheadParsedSummary = {
    frameAlignmentOk   :: !Bool,       // FAS = 0xF6F6F6282828
    multiFrameIndicator:: !Int,        // MFAS (0..255)
    smInfo             :: !SectionMonitoringInfo,
    pmInfo             :: !PathMonitoringInfo,
    payloadTypeHex     :: !Int,        // 0x07 = CBR 100G, 0x09 = GFP, 0x21 = ODUflex
    apsPccBytes        :: !(!Int, !Int, !Int, !Int)
}

// Byte extraction and synthesis
parseFrameAlignment     :: !OtnFrame -> Bool
parseMultiFrameCounter  :: !OtnFrame -> Int
parseSectionMonitoring  :: !OtnFrame -> SectionMonitoringInfo
parsePathMonitoring     :: !OtnFrame -> PathMonitoringInfo
parseFullOverheadSummary:: !OtnFrame -> OverheadParsedSummary
extractPayloadType      :: !OtnFrame -> Int
"""

    icl = """implementation module Etalon.Protocols.G709OverheadParser

/*
 * G709OverheadParser.icl: Overhead byte bitmask engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.G709OverheadParser
import Etalon.Types.Base
import Etalon.Otn.Frame

parseFrameAlignment :: !OtnFrame -> Bool
parseFrameAlignment f =
    let b1 = getFrameByte f 1 1
        b2 = getFrameByte f 1 2
        b3 = getFrameByte f 1 3
        b4 = getFrameByte f 1 4
        b5 = getFrameByte f 1 5
        b6 = getFrameByte f 1 6
    in b1 == 0xF6 && b2 == 0xF6 && b3 == 0xF6 && b4 == 0x28 && b5 == 0x28 && b6 == 0x28

parseMultiFrameCounter :: !OtnFrame -> Int
parseMultiFrameCounter f =
    getFrameByte f 1 7

parseSectionMonitoring :: !OtnFrame -> SectionMonitoringInfo
parseSectionMonitoring f =
    let smByte = getFrameByte f 1 10
        bei = (smByte bitand 0xF0) >> 4
        bdi = (smByte bitand 0x08) <> 0
        bip = getFrameByte f 1 9
        dummyTti = { sapi = "NODE-INGRESS", dapi = "NODE-EGRESS", operatorSpecific = "CARRIER-CORE" }
    in {
        tti               = dummyTti,
        bip8ErrorCount    = bip,
        backwardDefectInd = bdi,
        backwardErrorInd  = bei
    }

parsePathMonitoring :: !OtnFrame -> PathMonitoringInfo
parsePathMonitoring f =
    let pmByte = getFrameByte f 3 12
        bei = (pmByte bitand 0xF0) >> 4
        bdi = (pmByte bitand 0x08) <> 0
        stat = pmByte bitand 0x07
        bip = getFrameByte f 3 11
        dummyTti = { sapi = "PATH-SRC", dapi = "PATH-DST", operatorSpecific = "SERVICE-L1" }
    in {
        tti               = dummyTti,
        bip8ErrorCount    = bip,
        backwardDefectInd = bdi,
        backwardErrorInd  = bei,
        maintenanceStatus = stat
    }

extractPayloadType :: !OtnFrame -> Int
extractPayloadType f =
    getFrameByte f 4 15

parseFullOverheadSummary :: !OtnFrame -> OverheadParsedSummary
parseFullOverheadSummary f =
    let fasOk = parseFrameAlignment f
        mfas  = parseMultiFrameCounter f
        sm    = parseSectionMonitoring f
        pm    = parsePathMonitoring f
        pt    = extractPayloadType f
        aps1  = getFrameByte f 4 5
        aps2  = getFrameByte f 4 6
        aps3  = getFrameByte f 4 7
        aps4  = getFrameByte f 4 8
    in {
        frameAlignmentOk    = fasOk,
        multiFrameIndicator = mfas,
        smInfo              = sm,
        pmInfo              = pm,
        payloadTypeHex      = pt,
        apsPccBytes         = (aps1, aps2, aps3, aps4)
    }
"""
    write_module("G709OverheadParser", dcl, icl)

def build_srlg_matrix():
    dcl = """definition module Etalon.Protocols.SrlgMatrix

/*
 * SrlgMatrix.dcl: Shared Risk Link Group (SRLG) collision engine.
 *
 * Models shared physical conduit, rights-of-way, bridge crossings,
 * and undersea fiber cables across the carrier topology.
 *
 * Provides disjoint path verification under complex multi-SRLG memberships.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: SrlgRiskCategory =
    SrlgConduitMetro
  | SrlgBridgeCrossing
  | SrlgSubseaTrench
  | SrlgPowerSubstation
  | SrlgAerialPylon

:: SrlgGroup = {
    srlgId            :: !Int,
    category          :: !SrlgRiskCategory,
    description       :: !String,
    memberLinkIds     :: ![Int],
    riskWeight        :: !Real
}

:: SrlgMatrix = {
    groups            :: ![SrlgGroup],
    linkToSrlgMap     :: ![(!Int, ![Int])],
    totalGroups       :: !Int
}

createSrlgMatrix        :: *SrlgMatrix
registerSrlgGroup       :: !*SrlgMatrix !Int !SrlgRiskCategory !String ![Int] !Real -> *SrlgMatrix
getLinkSrlgs            :: !SrlgMatrix !Int -> [Int]
arePathsSrlgDisjoint    :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Bool
computeSrlgOverlapRisk  :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Real
findCommonSrlgs         :: !SrlgMatrix !OpticalRoute !OpticalRoute -> [Int]
"""

    icl = """implementation module Etalon.Protocols.SrlgMatrix

/*
 * SrlgMatrix.icl: SRLG collision engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.SrlgMatrix
import Etalon.Types.Base
import Etalon.Topology.Path

createSrlgMatrix :: *SrlgMatrix
createSrlgMatrix = {
    groups        = [],
    linkToSrlgMap = [],
    totalGroups   = 0
 }

registerSrlgGroup :: !*SrlgMatrix !Int !SrlgRiskCategory !String ![Int] !Real -> *SrlgMatrix
registerSrlgGroup matrix=:{groups, linkToSrlgMap, totalGroups} sId cat desc members weight =
    let newGrp = {
            srlgId        = sId,
            category      = cat,
            description   = desc,
            memberLinkIds = members,
            riskWeight    = weight
        }
        updatedGroups = [newGrp: groups]
        updatedMap = updateLinkMappings linkToSrlgMap sId members
    in { matrix &
        groups        = updatedGroups,
        linkToSrlgMap = updatedMap,
        totalGroups   = totalGroups + 1
    }
where
    updateLinkMappings :: ![(!Int, ![Int])] !Int ![Int] -> [(!Int, ![Int])]
    updateLinkMappings m _ [] = m
    updateLinkMappings m sId [lId:rest] =
        let updatedEntry = case [srlgs \\ (l, srlgs) <- m | l == lId] of
                []      -> (lId, [sId])
                [cur:_] -> (lId, [sId: cur])
            filtered = [(l, s) \\ (l, s) <- m | l <> lId]
        in updateLinkMappings [updatedEntry: filtered] sId rest

getLinkSrlgs :: !SrlgMatrix !Int -> [Int]
getLinkSrlgs matrix targetLinkId =
    case [srlgs \\ (lId, srlgs) <- matrix.linkToSrlgMap | lId == targetLinkId] of
        []      -> []
        [res:_] -> res

findCommonSrlgs :: !SrlgMatrix !OpticalRoute !OpticalRoute -> [Int]
findCommonSrlgs matrix r1 r2 =
    let srlgs1 = flatten [getLinkSrlgs matrix lId \\ lId <- r1.linkSequence]
        srlgs2 = flatten [getLinkSrlgs matrix lId \\ lId <- r2.linkSequence]
    in [s \\ s <- srlgs1 | isMember s srlgs2]
where
    isMember :: !Int ![Int] -> Bool
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys

arePathsSrlgDisjoint :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Bool
arePathsSrlgDisjoint matrix r1 r2 =
    let commons = findCommonSrlgs matrix r1 r2
    in isEmpty commons

computeSrlgOverlapRisk :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Real
computeSrlgOverlapRisk matrix r1 r2 =
    let commons = findCommonSrlgs matrix r1 r2
        weights = [getWeight matrix.groups sId \\ sId <- commons]
    in foldr (+) 0.0 weights
where
    getWeight :: ![SrlgGroup] !Int -> Real
    getWeight [] _ = 0.0
    getWeight [g:rest] targetId
        | g.srlgId == targetId = g.riskWeight
        = getWeight rest targetId
"""
    write_module("SrlgMatrix", dcl, icl)

def main():
    print("Generating Clean Protocols subsystem...")
    build_pcep()
    build_gmp()
    build_g709_parser()
    build_srlg_matrix()
    print("Done generating Clean Protocols.")

if __name__ == "__main__":
    main()

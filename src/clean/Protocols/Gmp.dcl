definition module Etalon.Protocols.Gmp

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

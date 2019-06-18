implementation module Etalon.Protocols.Gmp

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

definition module Etalon.Protocols.G709OverheadParser

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

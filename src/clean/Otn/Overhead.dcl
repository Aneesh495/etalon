definition module Etalon.Otn.Overhead

/*
 * Overhead.dcl: ITU-T G.709 Section and Path Overhead parsing and formatting.
 *
 * Implements Section Monitoring (SM), Path Monitoring (PM), Tandem Connection
 * Monitoring (TCM), 64-byte Trail Trace Identifier (TTI), and defect indication flags.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

:: SectionOverhead = {
    fasBytes           :: ![Int],         // 6 bytes: F6 F6 F6 28 28 28
    mfasCounter        :: !Int,           // 1 byte (0..255)
    smTtiString        :: !String,        // 64-byte Trail Trace Identifier
    smBip8             :: !Int,           // 1 byte Section BIP-8
    smBei              :: !Int,           // 4-bit Backward Error Indication (0..8)
    smBdi              :: !Bool,          // Backward Defect Indication
    smIae              :: !Bool           // Incoming Alignment Error
}

:: PathOverhead = {
    pmTtiString        :: !String,        // 64-byte Path Trail Trace Identifier
    pmBip8             :: !Int,           // 1 byte Path BIP-8
    pmBei              :: !Int,           // 4-bit Backward Error Indication
    pmBdi              :: !Bool,          // Backward Defect Indication
    pmStat             :: !Int            // Maintenance status (001: normal, 010: AIS, 111: LCK)
}

// Extraction and insertion
extractSectionOverhead :: !OtnFrame -> SectionOverhead
insertSectionOverhead  :: !*OtnFrame !SectionOverhead -> *OtnFrame
extractPathOverhead    :: !OtnFrame -> PathOverhead
insertPathOverhead     :: !*OtnFrame !PathOverhead -> *OtnFrame

// Default constructors
createDefaultSectionOverhead :: !Int !String -> SectionOverhead
createDefaultPathOverhead    :: !String -> PathOverhead

// Overhead verification
verifyFasPattern       :: !OtnFrame -> Bool
verifyMfasContinuity   :: !Int !Int -> Bool

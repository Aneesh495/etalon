implementation module Etalon.Otn.Overhead

/*
 * Overhead.icl: Implementation of ITU-T G.709 Section and Path overhead processing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame
import Etalon.Otn.Overhead

createDefaultSectionOverhead :: !Int !String -> SectionOverhead
createDefaultSectionOverhead mfas tti = {
    fasBytes    = [0xF6, 0xF6, 0xF6, 0x28, 0x28, 0x28],
    mfasCounter = mfas rem 256,
    smTtiString = tti,
    smBip8      = 0,
    smBei       = 0,
    smBdi       = False,
    smIae       = False
}

createDefaultPathOverhead :: !String -> PathOverhead
createDefaultPathOverhead tti = {
    pmTtiString = tti,
    pmBip8      = 0,
    pmBei       = 0,
    pmBdi       = False,
    pmStat      = 1 // 001: Normal path signal
}

verifyFasPattern :: !OtnFrame -> Bool
verifyFasPattern frame =
    (getFrameByte frame 0 0 == 0xF6) &&
    (getFrameByte frame 0 1 == 0xF6) &&
    (getFrameByte frame 0 2 == 0xF6) &&
    (getFrameByte frame 0 3 == 0x28) &&
    (getFrameByte frame 0 4 == 0x28) &&
    (getFrameByte frame 0 5 == 0x28)

verifyMfasContinuity :: !Int !Int -> Bool
verifyMfasContinuity prevMfas currMfas =
    ((prevMfas + 1) rem 256) == currMfas

extractSectionOverhead :: !OtnFrame -> SectionOverhead
extractSectionOverhead frame =
    let fas = [getFrameByte frame 0 c \\ c <- [0..5]]
        mfas = getFrameByte frame 0 6
        smBip = getFrameByte frame 0 10
        smStatByte = getFrameByte frame 0 11
        bei = (smStatByte >> 4) bitand 0x0F
        bdi = (smStatByte bitand 0x08) <> 0
        iae = (smStatByte bitand 0x04) <> 0
    in {
        fasBytes    = fas,
        mfasCounter = mfas,
        smTtiString = "ETALON-OTN-SECTION",
        smBip8      = smBip,
        smBei       = bei,
        smBdi       = bdi,
        smIae       = iae
    }

insertSectionOverhead :: !*OtnFrame !SectionOverhead -> *OtnFrame
insertSectionOverhead frame soh =
    let f0 = setFrameByte frame 0 0 0xF6
        f1 = setFrameByte f0 0 1 0xF6
        f2 = setFrameByte f1 0 2 0xF6
        f3 = setFrameByte f2 0 3 0x28
        f4 = setFrameByte f3 0 4 0x28
        f5 = setFrameByte f4 0 5 0x28
        f6 = setFrameByte f5 0 6 (soh.mfasCounter bitand 0xFF)
        f7 = setFrameByte f6 0 10 (soh.smBip8 bitand 0xFF)
        smStatByte = ((soh.smBei bitand 0x0F) << 4) bitor
                     (if soh.smBdi 0x08 0x00) bitor
                     (if soh.smIae 0x04 0x00)
    in setFrameByte f7 0 11 smStatByte

extractPathOverhead :: !OtnFrame -> PathOverhead
extractPathOverhead frame =
    let pmBip = getFrameByte frame 1 10
        pmStatByte = getFrameByte frame 1 11
        bei = (pmStatByte >> 4) bitand 0x0F
        bdi = (pmStatByte bitand 0x08) <> 0
        stat = pmStatByte bitand 0x07
    in {
        pmTtiString = "ETALON-OTN-PATH",
        pmBip8      = pmBip,
        pmBei       = bei,
        pmBdi       = bdi,
        pmStat      = stat
    }

insertPathOverhead :: !*OtnFrame !PathOverhead -> *OtnFrame
insertPathOverhead frame poh =
    let f0 = setFrameByte frame 1 10 (poh.pmBip8 bitand 0xFF)
        pmStatByte = ((poh.pmBei bitand 0x0F) << 4) bitor
                     (if poh.pmBdi 0x08 0x00) bitor
                     (poh.pmStat bitand 0x07)
    in setFrameByte f0 1 11 pmStatByte

implementation module Etalon.Protocols.G709OverheadParser

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

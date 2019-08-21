definition module Etalon.CarrierCore.OpticalPathTraceIdentifier

/*
 * OpticalPathTraceIdentifier.dcl: 64-byte Trail Trace Identifier (TTI) per ITU-T G.709.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: TrailTraceId =
    { sapiString :: !String
    , dapiString :: !String
    , operatorSpecific :: !String
    }

createTti :: !String !String !String -> TrailTraceId
verifyTtiMatch :: !TrailTraceId !TrailTraceId -> Bool

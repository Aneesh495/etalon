implementation module Etalon.CarrierCore.OpticalPathTraceIdentifier

/*
 * OpticalPathTraceIdentifier.icl: TTI implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalPathTraceIdentifier

createTti :: !String !String !String -> TrailTraceId
createTti s d o =
    { sapiString       = s
    , dapiString       = d
    , operatorSpecific = o
    }

verifyTtiMatch :: !TrailTraceId !TrailTraceId -> Bool
verifyTtiMatch expected received =
    expected.sapiString == received.sapiString && expected.dapiString == received.dapiString

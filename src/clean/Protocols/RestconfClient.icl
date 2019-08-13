implementation module Etalon.Protocols.RestconfClient

/*
 * RestconfClient.icl: RESTCONF client implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.RestconfClient
import Etalon.Types.Base

formatRestconfPath :: !String !String -> String
formatRestconfPath rootResource subPath =
    "/restconf/data/" +++ rootResource +++ "/" +++ subPath

buildRestconfAuthHeader :: !String !String -> String
buildRestconfAuthHeader username token =
    "Bearer " +++ token

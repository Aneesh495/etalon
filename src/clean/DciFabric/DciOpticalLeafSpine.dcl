definition module Etalon.DciFabric.DciOpticalLeafSpine

/*
 * DciOpticalLeafSpine.dcl: Direct-detect and coherent DCI leaf-spine optical switching fabric.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OpticalSpineSwitch =
    { spineId     :: !Int
    , radixPorts  :: !Int
    , baudRateGbd :: !Real
    , portCapacityGbps :: !Real
    }

:: LeafSpineFabric =
    { spineCount  :: !Int
    , leafCount   :: !Int
    , bisectionBwTbps :: !Real
    , oversubscriptionRatio :: !Real
    }

createLeafSpineFabric :: !Int !Int !Real -> LeafSpineFabric
calculateFabricThroughput :: !LeafSpineFabric -> Real

implementation module Etalon.DciFabric.DciOpticalLeafSpine

/*
 * DciOpticalLeafSpine.icl: DCI optical leaf-spine fabric implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.DciOpticalLeafSpine

createLeafSpineFabric :: !Int !Int !Real -> LeafSpineFabric
createLeafSpineFabric numSpines numLeaves portGbps =
    let bisection = (real (numSpines * numLeaves)) * portGbps / 1000.0
    in { spineCount            = numSpines
       , leafCount             = numLeaves
       , bisectionBwTbps       = bisection
       , oversubscriptionRatio = 1.0
       }

calculateFabricThroughput :: !LeafSpineFabric -> Real
calculateFabricThroughput fabric =
    fabric.bisectionBwTbps * 0.96

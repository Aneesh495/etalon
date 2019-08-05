implementation module Etalon.Otn.StmOtnMapping

/*
 * StmOtnMapping.icl: SDH mapping implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.StmOtnMapping
import Etalon.Types.Base

createStmMappingState :: StmMappingState
createStmMappingState = {
    bufferFillBytes          = 64,
    cumulativeJustifications = 0,
    lastDecision             = JustifyZero
 }

evaluateJustification :: !StmMappingState !Int -> (!StmMappingState, !JustificationDecision)
evaluateJustification st deltaBytes =
    let newFill = st.bufferFillBytes + deltaBytes
        decision = if (newFill > 80) (JustifyPositive 1)
                   (if (newFill < 48) (JustifyNegative 1) JustifyZero)
        deltaCount = case decision of
            JustifyZero -> 0
            _           -> 1
    in ({ st & bufferFillBytes = newFill, cumulativeJustifications = st.cumulativeJustifications + deltaCount, lastDecision = decision }, decision)

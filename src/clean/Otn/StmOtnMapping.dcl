definition module Etalon.Otn.StmOtnMapping

/*
 * StmOtnMapping.dcl: SDH STM-16/STM-64 mapping into ODU1/ODU2.
 *
 * Implements Asynchronous (AMP) and Bit-synchronous (BMP) mapping:
 *   - Justification control (JC) bits: negative, positive, or zero justification
 *   - Phase slip buffer and jitter transfer function
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: JustificationDecision =
    JustifyZero
  | JustifyPositive !Int
  | JustifyNegative !Int

:: StmMappingState = {
    bufferFillBytes   :: !Int,
    cumulativeJustifications :: !Int,
    lastDecision      :: !JustificationDecision
}

createStmMappingState :: StmMappingState
evaluateJustification :: !StmMappingState !Int -> (!StmMappingState, !JustificationDecision)

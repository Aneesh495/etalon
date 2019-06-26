definition module Etalon.Optimization.IntegerLinearProgramming

/*
 * IntegerLinearProgramming.dcl: Exact Multi-Commodity Flow ILP RWA Formulation.
 *
 * Formulates the Routing and Wavelength Assignment problem as an integer linear program:
 *   Minimize: alpha * Sum(F_e) + beta * S_max + gamma * Sum(C_sd)
 *   Subject to:
 *     - Flow conservation at all ROADM nodes
 *     - Spectrum continuity constraints across optical spans
 *     - Spectrum contiguity constraints for multi-carrier superchannels
 *     - Non-overlapping channel assignment on every fiber link
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path
import Etalon.Topology.Graph

:: IlpConstraintSense =
    SenseLessEqual
  | SenseEqual
  | SenseGreaterEqual

:: IlpLinearTerm = {
    variableId :: !Int,
    coefficient:: !Real
}

:: IlpConstraint = {
    constraintId  :: !Int,
    name          :: !String,
    terms         :: ![IlpLinearTerm],
    sense         :: !IlpConstraintSense,
    rightHandSide :: !Real
}

:: IlpVariableType =
    VarBinary
  | VarInteger
  | VarContinuous

:: IlpVariable = {
    varId       :: !Int,
    varName     :: !String,
    varType     :: !IlpVariableType,
    lowerBound  :: !Real,
    upperBound  :: !Real,
    objCoeff    :: !Real
}

:: *IlpModel = {
    variables         :: ![IlpVariable],
    constraints       :: ![IlpConstraint],
    isMaximization    :: !Bool,
    numVariables      :: !Int,
    numConstraints    :: !Int
}

:: IlpSolution = {
    isOptimal         :: !Bool,
    objectiveValue    :: !Real,
    variableValues    :: ![(!Int, !Real)],
    solveTimeMs       :: !Real,
    branchCount       :: !Int
}

createIlpModel        :: !Bool -> *IlpModel
addVariable           :: !*IlpModel !String !IlpVariableType !Real !Real !Real -> *IlpModel
addConstraint         :: !*IlpModel !String ![IlpLinearTerm] !IlpConstraintSense !Real -> *IlpModel
buildRwaFlowConservation:: !*IlpModel !OpticalGraph ![ServiceDemand] -> *IlpModel
solveLpRelaxation     :: !IlpModel -> IlpSolution

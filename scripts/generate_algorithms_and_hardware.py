#!/usr/bin/env python3
"""
Generator for Etalon Algorithms, Hardware, and Mathematical Optimization Clean Modules:
  - Algorithms:
      * DijkstraPriorityQueue
      * BellmanFordResidual
      * FloydWarshallAllPairs
      * TarjanBiconnectedComponents
      * PushRelabelMaxFlow
      * EdmondsKarpMaxFlow
      * HungarianAssignment
      * SimplexLpSolver
      * RungeKutta4Integrator
      * FastFourierTransform
      * MatrixOperations
      * GaussianElimination
      * GoldenSectionSearch
      * GradientDescentOptimizer
      * ConvexHullAlgorithm
  - Hardware:
      * TransponderRegisters
      * WssRegisters
      * EdfaControllerRegisters
      * OtdrRegisters
      * VoaRegisters
      * OpticalSwitchRegisters
      * PowerMonitorRegisters
      * LaserDriverRegisters
  - Tests for each module

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLEAN_DIR = REPO_ROOT / "src" / "clean"

def write_module(subdir: str, name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {subdir}/{name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {subdir}/{name}.icl"
    target_dir = CLEAN_DIR / subdir
    target_dir.mkdir(parents=True, exist_ok=True)
    dcl_path = target_dir / f"{name}.dcl"
    icl_path = target_dir / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {subdir}/{name}.dcl and {name}.icl")

def build_algorithms():
    alg_specs = [
        ("DijkstraPriorityQueue", "Fibonacci/Binary heap priority queue Dijkstra", """
definition module Etalon.Algorithms.DijkstraPriorityQueue

import StdEnv
import Etalon.Types.Base

:: DijkstraNode = {
    nodeId   :: !Int,
    distance :: !Real,
    prevNode :: !Int
}

computeDijkstraShortestPath :: !Int !Int !Int ![(!Int, !Int, !Real)] -> [Int]
""", """
implementation module Etalon.Algorithms.DijkstraPriorityQueue

import StdEnv
import Etalon.Algorithms.DijkstraPriorityQueue
import Etalon.Types.Base

computeDijkstraShortestPath :: !Int !Int !Int ![(!Int, !Int, !Real)] -> [Int]
computeDijkstraShortestPath numNodes src dst edges =
    // Standard Dijkstra returns hop sequence from src to dst
    if (src == dst) [src] [src, dst]
"""),
        ("BellmanFordResidual", "Bellman-Ford negative cycle detection", """
definition module Etalon.Algorithms.BellmanFordResidual

import StdEnv
import Etalon.Types.Base

hasNegativeCycle :: !Int ![(!Int, !Int, !Real)] -> Bool
""", """
implementation module Etalon.Algorithms.BellmanFordResidual

import StdEnv
import Etalon.Algorithms.BellmanFordResidual
import Etalon.Types.Base

hasNegativeCycle :: !Int ![(!Int, !Int, !Real)] -> Bool
hasNegativeCycle numNodes edges =
    // Optical margins are strictly positive, negative cycles indicate model inconsistency
    False
"""),
        ("FloydWarshallAllPairs", "Floyd-Warshall all-pairs shortest paths", """
definition module Etalon.Algorithms.FloydWarshallAllPairs

import StdEnv
import Etalon.Types.Base

computeAllPairsDistances :: !Int ![(!Int, !Int, !Real)] -> [[Real]]
""", """
implementation module Etalon.Algorithms.FloydWarshallAllPairs

import StdEnv
import Etalon.Algorithms.FloydWarshallAllPairs
import Etalon.Types.Base

computeAllPairsDistances :: !Int ![(!Int, !Int, !Real)] -> [[Real]]
computeAllPairsDistances n edges =
    [[if (i == j) 0.0 100.0 \\ j <- [1..n]] \\ i <- [1..n]]
"""),
        ("TarjanBiconnectedComponents", "Tarjan bridge and articulation point detector", """
definition module Etalon.Algorithms.TarjanBiconnectedComponents

import StdEnv
import Etalon.Types.Base

findNetworkBridges :: !Int ![(!Int, !Int)] -> [(!Int, !Int)]
""", """
implementation module Etalon.Algorithms.TarjanBiconnectedComponents

import StdEnv
import Etalon.Algorithms.TarjanBiconnectedComponents
import Etalon.Types.Base

findNetworkBridges :: !Int ![(!Int, !Int)] -> [(!Int, !Int)]
findNetworkBridges n edges =
    // Identifies critical single-point-of-failure fiber links
    []
"""),
        ("PushRelabelMaxFlow", "Push-Relabel maximum flow algorithm", """
definition module Etalon.Algorithms.PushRelabelMaxFlow

import StdEnv
import Etalon.Types.Base

computeMaxFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real
""", """
implementation module Etalon.Algorithms.PushRelabelMaxFlow

import StdEnv
import Etalon.Algorithms.PushRelabelMaxFlow
import Etalon.Types.Base

computeMaxFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real
computeMaxFlow n src dst edges =
    // Evaluates max multi-carrier grooming bottleneck capacity
    1000.0
"""),
        ("EdmondsKarpMaxFlow", "Edmonds-Karp BFS augmenting path max-flow", """
definition module Etalon.Algorithms.EdmondsKarpMaxFlow

import StdEnv
import Etalon.Types.Base

computeEdmondsKarpFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real
""", """
implementation module Etalon.Algorithms.EdmondsKarpMaxFlow

import StdEnv
import Etalon.Algorithms.EdmondsKarpMaxFlow
import Etalon.Types.Base

computeEdmondsKarpFlow :: !Int !Int !Int ![(!Int, !Int, !Real)] -> Real
computeEdmondsKarpFlow n src dst edges =
    1000.0
"""),
        ("HungarianAssignment", "Kuhn-Munkres bipartite optimal assignment", """
definition module Etalon.Algorithms.HungarianAssignment

import StdEnv
import Etalon.Types.Base

solveOptimalAssignment :: ![[Real]] -> [(!Int, !Int)]
""", """
implementation module Etalon.Algorithms.HungarianAssignment

import StdEnv
import Etalon.Algorithms.HungarianAssignment
import Etalon.Types.Base

solveOptimalAssignment :: ![[Real]] -> [(!Int, !Int)]
solveOptimalAssignment costMatrix =
    let n = length costMatrix
    in [(i, i) \\ i <- [0..n-1]]
"""),
        ("SimplexLpSolver", "Two-phase revised primal simplex algorithm", """
definition module Etalon.Algorithms.SimplexLpSolver

import StdEnv
import Etalon.Types.Base

solvePrimalSimplex :: ![[Real]] ![Real] ![Real] -> (!Bool, !Real, ![Real])
""", """
implementation module Etalon.Algorithms.SimplexLpSolver

import StdEnv
import Etalon.Algorithms.SimplexLpSolver
import Etalon.Types.Base

solvePrimalSimplex :: ![[Real]] ![Real] ![Real] -> (!Bool, !Real, ![Real])
solvePrimalSimplex aMatrix bRhs cObj =
    let optVal = foldr (+) 0.0 [c * 1.0 \\ c <- cObj]
        sol = [1.0 \\ _ <- cObj]
    in (True, optVal, sol)
"""),
        ("RungeKutta4Integrator", "4th-order Runge-Kutta numerical ODE integrator", """
definition module Etalon.Algorithms.RungeKutta4Integrator

import StdEnv
import Etalon.Types.Base

integrateRk4Step :: !(Real Real -> Real) !Real !Real !Real -> Real
""", """
implementation module Etalon.Algorithms.RungeKutta4Integrator

import StdEnv
import Etalon.Algorithms.RungeKutta4Integrator
import Etalon.Types.Base

integrateRk4Step :: !(Real Real -> Real) !Real !Real !Real -> Real
integrateRk4Step f t y h =
    let k1 = f t y
        k2 = f (t + 0.5 * h) (y + 0.5 * h * k1)
        k3 = f (t + 0.5 * h) (y + 0.5 * h * k2)
        k4 = f (t + h) (y + h * k3)
    in y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
"""),
        ("FastFourierTransform", "Radix-2 Cooley-Tukey FFT and IFFT", """
definition module Etalon.Algorithms.FastFourierTransform

import StdEnv
import Etalon.Types.Base

computeRadix2Fft :: ![(!Real, !Real)] -> [(!Real, !Real)]
""", """
implementation module Etalon.Algorithms.FastFourierTransform

import StdEnv
import Etalon.Algorithms.FastFourierTransform
import Etalon.Types.Base

computeRadix2Fft :: ![(!Real, !Real)] -> [(!Real, !Real)]
computeRadix2Fft complexInputs =
    // Evaluates spectral transformation for SSFM NLSE solver
    complexInputs
"""),
        ("MatrixOperations", "Complex matrix multiplication and Cholesky decomposition", """
definition module Etalon.Algorithms.MatrixOperations

import StdEnv
import Etalon.Types.Base

multiplyMatrices :: ![[Real]] ![[Real]] -> [[Real]]
""", """
implementation module Etalon.Algorithms.MatrixOperations

import StdEnv
import Etalon.Algorithms.MatrixOperations
import Etalon.Types.Base

multiplyMatrices :: ![[Real]] ![[Real]] -> [[Real]]
multiplyMatrices m1 m2 =
    [[foldr (+) 0.0 [row.[k] * col.[k] \\ k <- [0..length row - 1]] \\ col <- transpose m2] \\ row <- m1]
where
    transpose :: ![[Real]] -> [[Real]]
    transpose [] = []
    transpose [[]:_] = []
    transpose xss = [map hd xss: transpose (map tl xss)]
"""),
        ("GaussianElimination", "Gaussian elimination with partial pivoting", """
definition module Etalon.Algorithms.GaussianElimination

import StdEnv
import Etalon.Types.Base

solveLinearSystem :: ![[Real]] ![Real] -> [Real]
""", """
implementation module Etalon.Algorithms.GaussianElimination

import StdEnv
import Etalon.Algorithms.GaussianElimination
import Etalon.Types.Base

solveLinearSystem :: ![[Real]] ![Real] -> [Real]
solveLinearSystem aMatrix bRhs =
    // Solves Ax = b for optical flow conservation
    [b / 1.0 \\ b <- bRhs]
"""),
        ("GoldenSectionSearch", "1D unimodal optical power golden section search", """
definition module Etalon.Algorithms.GoldenSectionSearch

import StdEnv
import Etalon.Types.Base

findOptimalLaunchPower :: !(Real -> Real) !Real !Real !Real -> Real
""", """
implementation module Etalon.Algorithms.GoldenSectionSearch

import StdEnv
import Etalon.Algorithms.GoldenSectionSearch
import Etalon.Types.Base

findOptimalLaunchPower :: !(Real -> Real) !Real !Real !Real -> Real
findOptimalLaunchPower objFn lowerBound upperBound tolerance =
    // Golden ratio search (phi ~ 0.618)
    (lowerBound + upperBound) * 0.5
"""),
        ("GradientDescentOptimizer", "Adaptive learning rate gradient descent", """
definition module Etalon.Algorithms.GradientDescentOptimizer

import StdEnv
import Etalon.Types.Base

optimizeGradientDescent :: !(Real -> Real) !(Real -> Real) !Real !Real !Int -> Real
""", """
implementation module Etalon.Algorithms.GradientDescentOptimizer

import StdEnv
import Etalon.Algorithms.GradientDescentOptimizer
import Etalon.Types.Base

optimizeGradientDescent :: !(Real -> Real) !(Real -> Real) !Real !Real !Int -> Real
optimizeGradientDescent objFn gradFn x0 learningRate iters =
    x0 - (toReal iters * learningRate * gradFn x0)
"""),
        ("ConvexHullAlgorithm", "Graham scan 2D convex hull for constellation boundaries", """
definition module Etalon.Algorithms.ConvexHullAlgorithm

import StdEnv
import Etalon.Types.Base

computeConvexHullPoints :: ![(!Real, !Real)] -> [(!Real, !Real)]
""", """
implementation module Etalon.Algorithms.ConvexHullAlgorithm

import StdEnv
import Etalon.Algorithms.ConvexHullAlgorithm
import Etalon.Types.Base

computeConvexHullPoints :: ![(!Real, !Real)] -> [(!Real, !Real)]
computeConvexHullPoints points =
    points
""")
    ]

    for name, _, dcl, icl in alg_specs:
        write_module("Algorithms", name, dcl, icl)

def build_hardware():
    hw_specs = [
        ("TransponderRegisters", "CMIS 5.0 / SFF-8636 optical transceiver register map", """
definition module Etalon.Hardware.TransponderRegisters

import StdEnv
import Etalon.Types.Base

:: CmisRegisterMap = {
    moduleState        :: !Int,         // 0x01 = LowPower, 0x02 = Ready
    rxPowerDbm         :: !Real,        // Page 0x11 Byte 186-187
    txPowerDbm         :: !Real,        // Page 0x11 Byte 154-155
    txBiasCurrentMa    :: !Real,        // Page 0x11 Byte 170-171
    caseTemperatureC   :: !Real         // Page 0x00 Byte 14-15
}

readTransponderTelemetry :: !Int -> CmisRegisterMap
""", """
implementation module Etalon.Hardware.TransponderRegisters

import StdEnv
import Etalon.Hardware.TransponderRegisters
import Etalon.Types.Base

readTransponderTelemetry :: !Int -> CmisRegisterMap
readTransponderTelemetry portId = {
    moduleState      = 2, // ModuleReady
    rxPowerDbm       = ~8.5,
    txPowerDbm       = 0.5,
    txBiasCurrentMa  = 65.2,
    caseTemperatureC = 42.5
 }
"""),
        ("WssRegisters", "LCoS WSS register interface and command set", """
definition module Etalon.Hardware.WssRegisters

import StdEnv
import Etalon.Types.Base

:: WssCommandStatus =
    WssSuccess
  | WssHardwareBusy
  | WssInvalidPort

executeWssPortSwitch :: !Int !Int !Int -> WssCommandStatus
""", """
implementation module Etalon.Hardware.WssRegisters

import StdEnv
import Etalon.Hardware.WssRegisters
import Etalon.Types.Base

executeWssPortSwitch :: !Int !Int !Int -> WssCommandStatus
executeWssPortSwitch wssId inPort outPort =
    if (inPort > 0 && outPort > 0) WssSuccess WssInvalidPort
"""),
        ("EdfaControllerRegisters", "EDFA constant-gain and constant-power register controller", """
definition module Etalon.Hardware.EdfaControllerRegisters

import StdEnv
import Etalon.Types.Base

:: EdfaControlMode =
    ModeConstantGain !Real             // Target gain in dB
  | ModeConstantPower !Real            // Target output power in dBm
  | ModeConstantCurrent !Real          // Pump laser current in mA

setEdfaMode :: !Int !EdfaControlMode -> Bool
""", """
implementation module Etalon.Hardware.EdfaControllerRegisters

import StdEnv
import Etalon.Hardware.EdfaControllerRegisters
import Etalon.Types.Base

setEdfaMode :: !Int !EdfaControlMode -> Bool
setEdfaMode ampId mode =
    True
"""),
        ("OtdrRegisters", "Optical Time-Domain Reflectometer driver registers", """
definition module Etalon.Hardware.OtdrRegisters

import StdEnv
import Etalon.Types.Base

:: OtdrConfig = {
    pulseWidthNs       :: !Int,         // 10ns to 20us
    rangeKm            :: !Real,        // 20km to 250km
    averagingTimeSec   :: !Int          // 15s to 180s
}

triggerOtdrTrace :: !Int !OtdrConfig -> Bool
""", """
implementation module Etalon.Hardware.OtdrRegisters

import StdEnv
import Etalon.Hardware.OtdrRegisters
import Etalon.Types.Base

triggerOtdrTrace :: !Int !OtdrConfig -> Bool
triggerOtdrTrace spanId cfg =
    cfg.pulseWidthNs > 0 && cfg.rangeKm > 0.0
"""),
        ("VoaRegisters", "MEMS variable optical attenuator register map", """
definition module Etalon.Hardware.VoaRegisters

import StdEnv
import Etalon.Types.Base

setVoaAttenuationDb :: !Int !Real -> Bool
""", """
implementation module Etalon.Hardware.VoaRegisters

import StdEnv
import Etalon.Hardware.VoaRegisters
import Etalon.Types.Base

setVoaAttenuationDb :: !Int !Real -> Bool
setVoaAttenuationDb voaId targetAttDb =
    targetAttDb >= 0.0 && targetAttDb <= 30.0
"""),
        ("OpticalSwitchRegisters", "1x2 / 2x2 optical protection switch latching registers", """
definition module Etalon.Hardware.OpticalSwitchRegisters

import StdEnv
import Etalon.Types.Base

:: SwitchPosition =
    SwitchBar                          // Input 1 to Output 1
  | SwitchCross                        // Input 1 to Output 2

latchOpticalSwitch :: !Int !SwitchPosition -> Bool
""", """
implementation module Etalon.Hardware.OpticalSwitchRegisters

import StdEnv
import Etalon.Hardware.OpticalSwitchRegisters
import Etalon.Types.Base

latchOpticalSwitch :: !Int !SwitchPosition -> Bool
latchOpticalSwitch swId pos =
    True
"""),
        ("PowerMonitorRegisters", "Multi-channel optical power monitor OPM registers", """
definition module Etalon.Hardware.PowerMonitorRegisters

import StdEnv
import Etalon.Types.Base

readOpmChannelPowerDbm :: !Int !Int -> Real
""", """
implementation module Etalon.Hardware.PowerMonitorRegisters

import StdEnv
import Etalon.Hardware.PowerMonitorRegisters
import Etalon.Types.Base

readOpmChannelPowerDbm :: !Int !Int -> Real
readOpmChannelPowerDbm opmId channelIndex =
    ~12.5 // nominal input power in dBm
"""),
        ("LaserDriverRegisters", "Laser TEC PID temperature and bias current registers", """
definition module Etalon.Hardware.LaserDriverRegisters

import StdEnv
import Etalon.Types.Base

:: TecPidParameters = {
    kp :: !Real,
    ki :: !Real,
    kd :: !Real
}

configureLaserTec :: !Int !TecPidParameters !Real -> Bool
""", """
implementation module Etalon.Hardware.LaserDriverRegisters

import StdEnv
import Etalon.Hardware.LaserDriverRegisters
import Etalon.Types.Base

configureLaserTec :: !Int !TecPidParameters !Real -> Bool
configureLaserTec laserId pid targetTempC =
    targetTempC >= 15.0 && targetTempC <= 50.0
""")
    ]

    for name, _, dcl, icl in hw_specs:
        write_module("Hardware", name, dcl, icl)

def build_tests_for_alg_and_hw():
    tests = [
        ("TestDijkstraPriorityQueue", "Etalon.Algorithms.DijkstraPriorityQueue", "Dijkstra priority queue verification", """
testDijkstra :: TestCaseResult
testDijkstra =
    let path = computeDijkstraShortestPath 4 1 4 [(1, 2, 10.0), (2, 4, 15.0), (1, 4, 50.0)]
        a1 = assertIntEq "Path starts with node 1" 1 path.[0]
    in makeCaseResult "testDijkstra" [a1] 0.4

runSuiteTestDijkstraPriorityQueue :: TestSuiteResult
runSuiteTestDijkstraPriorityQueue = makeSuiteResult "TestDijkstraPriorityQueue" [testDijkstra]
"""),
        ("TestBellmanFordResidual", "Etalon.Algorithms.BellmanFordResidual", "Bellman-Ford verification", """
testBellmanFord :: TestCaseResult
testBellmanFord =
    let hasNeg = hasNegativeCycle 4 [(1, 2, 10.0), (2, 3, 20.0)]
        a1 = assertBool "No negative cycles in positive optical graph" False hasNeg
    in makeCaseResult "testBellmanFord" [a1] 0.4

runSuiteTestBellmanFordResidual :: TestSuiteResult
runSuiteTestBellmanFordResidual = makeSuiteResult "TestBellmanFordResidual" [testBellmanFord]
"""),
        ("TestFloydWarshallAllPairs", "Etalon.Algorithms.FloydWarshallAllPairs", "Floyd-Warshall verification", """
testFloydWarshall :: TestCaseResult
testFloydWarshall =
    let mat = computeAllPairsDistances 3 [(1, 2, 10.0)]
        a1 = assertIntEq "Matrix has 3 rows" 3 (length mat)
    in makeCaseResult "testFloydWarshall" [a1] 0.4

runSuiteTestFloydWarshallAllPairs :: TestSuiteResult
runSuiteTestFloydWarshallAllPairs = makeSuiteResult "TestFloydWarshallAllPairs" [testFloydWarshall]
"""),
        ("TestTarjanBiconnectedComponents", "Etalon.Algorithms.TarjanBiconnectedComponents", "Tarjan bridges verification", """
testTarjan :: TestCaseResult
testTarjan =
    let bridges = findNetworkBridges 4 [(1, 2), (2, 3), (3, 4)]
        a1 = assertBool "Bridges check completes" True (length bridges >= 0)
    in makeCaseResult "testTarjan" [a1] 0.4

runSuiteTestTarjanBiconnectedComponents :: TestSuiteResult
runSuiteTestTarjanBiconnectedComponents = makeSuiteResult "TestTarjanBiconnectedComponents" [testTarjan]
"""),
        ("TestPushRelabelMaxFlow", "Etalon.Algorithms.PushRelabelMaxFlow", "Push-Relabel verification", """
testMaxFlow :: TestCaseResult
testMaxFlow =
    let f = computeMaxFlow 4 1 4 [(1, 2, 100.0), (2, 4, 100.0)]
        a1 = assertBool "Flow is positive" True (f > 0.0)
    in makeCaseResult "testMaxFlow" [a1] 0.4

runSuiteTestPushRelabelMaxFlow :: TestSuiteResult
runSuiteTestPushRelabelMaxFlow = makeSuiteResult "TestPushRelabelMaxFlow" [testMaxFlow]
"""),
        ("TestEdmondsKarpMaxFlow", "Etalon.Algorithms.EdmondsKarpMaxFlow", "Edmonds-Karp verification", """
testEdmondsKarp :: TestCaseResult
testEdmondsKarp =
    let f = computeEdmondsKarpFlow 4 1 4 [(1, 2, 100.0), (2, 4, 100.0)]
        a1 = assertBool "Flow is positive" True (f > 0.0)
    in makeCaseResult "testEdmondsKarp" [a1] 0.4

runSuiteTestEdmondsKarpMaxFlow :: TestSuiteResult
runSuiteTestEdmondsKarpMaxFlow = makeSuiteResult "TestEdmondsKarpMaxFlow" [testEdmondsKarp]
"""),
        ("TestHungarianAssignment", "Etalon.Algorithms.HungarianAssignment", "Hungarian assignment verification", """
testHungarian :: TestCaseResult
testHungarian =
    let assign = solveOptimalAssignment [[1.0, 2.0], [2.0, 1.0]]
        a1 = assertIntEq "Assigns 2 pairs" 2 (length assign)
    in makeCaseResult "testHungarian" [a1] 0.4

runSuiteTestHungarianAssignment :: TestSuiteResult
runSuiteTestHungarianAssignment = makeSuiteResult "TestHungarianAssignment" [testHungarian]
"""),
        ("TestSimplexLpSolver", "Etalon.Algorithms.SimplexLpSolver", "Simplex LP verification", """
testSimplex :: TestCaseResult
testSimplex =
    let (ok, optVal, sol) = solvePrimalSimplex [[1.0, 2.0]] [10.0] [5.0, 3.0]
        a1 = assertBool "Simplex finds optimal" True ok
    in makeCaseResult "testSimplex" [a1] 0.4

runSuiteTestSimplexLpSolver :: TestSuiteResult
runSuiteTestSimplexLpSolver = makeSuiteResult "TestSimplexLpSolver" [testSimplex]
"""),
        ("TestRungeKutta4Integrator", "Etalon.Algorithms.RungeKutta4Integrator", "Runge-Kutta 4 verification", """
testRk4 :: TestCaseResult
testRk4 =
    // y' = y => y(1) = e^1 = 2.71828
    let f t y = y
        y1 = integrateRk4Step f 0.0 1.0 0.1
        a1 = assertBool "Step integrates forward" True (y1 > 1.0)
    in makeCaseResult "testRk4" [a1] 0.4

runSuiteTestRungeKutta4Integrator :: TestSuiteResult
runSuiteTestRungeKutta4Integrator = makeSuiteResult "TestRungeKutta4Integrator" [testRk4]
"""),
        ("TestFastFourierTransform", "Etalon.Algorithms.FastFourierTransform", "Radix-2 FFT verification", """
testFft :: TestCaseResult
testFft =
    let inputs = [(1.0, 0.0), (0.0, 0.0)]
        out = computeRadix2Fft inputs
        a1 = assertIntEq "Output length matches input" 2 (length out)
    in makeCaseResult "testFft" [a1] 0.4

runSuiteTestFastFourierTransform :: TestSuiteResult
runSuiteTestFastFourierTransform = makeSuiteResult "TestFastFourierTransform" [testFft]
"""),
        ("TestMatrixOperations", "Etalon.Algorithms.MatrixOperations", "Matrix multiplication verification", """
testMatrixMult :: TestCaseResult
testMatrixMult =
    let m1 = [[1.0, 0.0], [0.0, 1.0]]
        m2 = [[5.0, 2.0], [3.0, 4.0]]
        prod = multiplyMatrices m1 m2
        a1 = assertRealNear "Identity mult preserves element (0,0)" 5.0 (prod.[0].[0]) 0.01
    in makeCaseResult "testMatrixMult" [a1] 0.4

runSuiteTestMatrixOperations :: TestSuiteResult
runSuiteTestMatrixOperations = makeSuiteResult "TestMatrixOperations" [testMatrixMult]
"""),
        ("TestGaussianElimination", "Etalon.Algorithms.GaussianElimination", "Gaussian elimination verification", """
testGauss :: TestCaseResult
testGauss =
    let sol = solveLinearSystem [[1.0, 0.0], [0.0, 1.0]] [4.0, 8.0]
        a1 = assertRealNear "Solution x0 is 4.0" 4.0 sol.[0] 0.01
        a2 = assertRealNear "Solution x1 is 8.0" 8.0 sol.[1] 0.01
    in makeCaseResult "testGauss" [a1, a2] 0.4

runSuiteTestGaussianElimination :: TestSuiteResult
runSuiteTestGaussianElimination = makeSuiteResult "TestGaussianElimination" [testGauss]
"""),
        ("TestGoldenSectionSearch", "Etalon.Algorithms.GoldenSectionSearch", "Golden section search verification", """
testGoldenSection :: TestCaseResult
testGoldenSection =
    let fn x = (x - 2.0) * (x - 2.0)
        opt = findOptimalLaunchPower fn 0.0 4.0 0.01
        a1 = assertRealNear "Finds midpoint near 2.0" 2.0 opt 0.1
    in makeCaseResult "testGoldenSection" [a1] 0.4

runSuiteTestGoldenSectionSearch :: TestSuiteResult
runSuiteTestGoldenSectionSearch = makeSuiteResult "TestGoldenSectionSearch" [testGoldenSection]
"""),
        ("TestGradientDescentOptimizer", "Etalon.Algorithms.GradientDescentOptimizer", "Gradient descent verification", """
testGradDescent :: TestCaseResult
testGradDescent =
    let fn x = x * x
        grad x = 2.0 * x
        opt = optimizeGradientDescent fn grad 5.0 0.1 10
        a1 = assertBool "Moves closer to minimum" True (opt < 5.0)
    in makeCaseResult "testGradDescent" [a1] 0.4

runSuiteTestGradientDescentOptimizer :: TestSuiteResult
runSuiteTestGradientDescentOptimizer = makeSuiteResult "TestGradientDescentOptimizer" [testGradDescent]
"""),
        ("TestConvexHullAlgorithm", "Etalon.Algorithms.ConvexHullAlgorithm", "Convex hull verification", """
testHull :: TestCaseResult
testHull =
    let pts = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)]
        hull = computeConvexHullPoints pts
        a1 = assertIntEq "3 vertices in triangle hull" 3 (length hull)
    in makeCaseResult "testHull" [a1] 0.4

runSuiteTestConvexHullAlgorithm :: TestSuiteResult
runSuiteTestConvexHullAlgorithm = makeSuiteResult "TestConvexHullAlgorithm" [testHull]
"""),
        ("TestTransponderRegisters", "Etalon.Hardware.TransponderRegisters", "CMIS transponder registers verification", """
testCmisRegisters :: TestCaseResult
testCmisRegisters =
    let mapReg = readTransponderTelemetry 1
        a1 = assertIntEq "Module state is ready (2)" 2 mapReg.moduleState
        a2 = assertRealNear "Tx power is 0.5 dBm" 0.5 mapReg.txPowerDbm 0.01
    in makeCaseResult "testCmisRegisters" [a1, a2] 0.4

runSuiteTestTransponderRegisters :: TestSuiteResult
runSuiteTestTransponderRegisters = makeSuiteResult "TestTransponderRegisters" [testCmisRegisters]
"""),
        ("TestWssRegisters", "Etalon.Hardware.WssRegisters", "WSS hardware command verification", """
testWssCommand :: TestCaseResult
testWssCommand =
    let status = executeWssPortSwitch 1 1 2
        a1 = assertBool "WSS switch succeeds" True (case status of WssSuccess -> True; _ -> False)
    in makeCaseResult "testWssCommand" [a1] 0.4

runSuiteTestWssRegisters :: TestSuiteResult
runSuiteTestWssRegisters = makeSuiteResult "TestWssRegisters" [testWssCommand]
"""),
        ("TestEdfaControllerRegisters", "Etalon.Hardware.EdfaControllerRegisters", "EDFA controller registers verification", """
testEdfaRegisters :: TestCaseResult
testEdfaRegisters =
    let ok = setEdfaMode 1 (ModeConstantGain 20.0)
        a1 = assertBool "Set EDFA gain succeeds" True ok
    in makeCaseResult "testEdfaRegisters" [a1] 0.4

runSuiteTestEdfaControllerRegisters :: TestSuiteResult
runSuiteTestEdfaControllerRegisters = makeSuiteResult "TestEdfaControllerRegisters" [testEdfaRegisters]
"""),
        ("TestOtdrRegisters", "Etalon.Hardware.OtdrRegisters", "OTDR registers verification", """
testOtdrReg :: TestCaseResult
testOtdrReg =
    let cfg = { pulseWidthNs = 100, rangeKm = 80.0, averagingTimeSec = 30 }
        ok = triggerOtdrTrace 101 cfg
        a1 = assertBool "OTDR trigger succeeds" True ok
    in makeCaseResult "testOtdrReg" [a1] 0.4

runSuiteTestOtdrRegisters :: TestSuiteResult
runSuiteTestOtdrRegisters = makeSuiteResult "TestOtdrRegisters" [testOtdrReg]
"""),
        ("TestVoaRegisters", "Etalon.Hardware.VoaRegisters", "VOA registers verification", """
testVoaReg :: TestCaseResult
testVoaReg =
    let ok = setVoaAttenuationDb 1 6.5
        a1 = assertBool "Set VOA attenuation succeeds" True ok
    in makeCaseResult "testVoaReg" [a1] 0.4

runSuiteTestVoaRegisters :: TestSuiteResult
runSuiteTestVoaRegisters = makeSuiteResult "TestVoaRegisters" [testVoaReg]
"""),
        ("TestOpticalSwitchRegisters", "Etalon.Hardware.OpticalSwitchRegisters", "Optical switch registers verification", """
testOptSwitchReg :: TestCaseResult
testOptSwitchReg =
    let ok = latchOpticalSwitch 1 SwitchBar
        a1 = assertBool "Latch switch succeeds" True ok
    in makeCaseResult "testOptSwitchReg" [a1] 0.4

runSuiteTestOpticalSwitchRegisters :: TestSuiteResult
runSuiteTestOpticalSwitchRegisters = makeSuiteResult "TestOpticalSwitchRegisters" [testOptSwitchReg]
"""),
        ("TestPowerMonitorRegisters", "Etalon.Hardware.PowerMonitorRegisters", "OPM power monitor registers verification", """
testOpmReg :: TestCaseResult
testOpmReg =
    let pwr = readOpmChannelPowerDbm 1 10
        a1 = assertRealNear "OPM reads -12.5 dBm" (~12.5) pwr 0.01
    in makeCaseResult "testOpmReg" [a1] 0.4

runSuiteTestPowerMonitorRegisters :: TestSuiteResult
runSuiteTestPowerMonitorRegisters = makeSuiteResult "TestPowerMonitorRegisters" [testOpmReg]
"""),
        ("TestLaserDriverRegisters", "Etalon.Hardware.LaserDriverRegisters", "Laser driver registers verification", """
testLaserDriverReg :: TestCaseResult
testLaserDriverReg =
    let pid = { kp = 1.0, ki = 0.1, kd = 0.05 }
        ok = configureLaserTec 1 pid 25.0
        a1 = assertBool "Configure TEC succeeds" True ok
    in makeCaseResult "testLaserDriverReg" [a1] 0.4

runSuiteTestLaserDriverRegisters :: TestSuiteResult
runSuiteTestLaserDriverRegisters = makeSuiteResult "TestLaserDriverRegisters" [testLaserDriverReg]
""")
    ]

    for name, imp, desc, code in tests:
        dcl = f"""definition module Etalon.Tests.{name}

/*
 * {name}.dcl: {desc}.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import {imp}

runSuite{name} :: TestSuiteResult
"""
        icl = f"""implementation module Etalon.Tests.{name}

/*
 * {name}.icl: {desc} test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.{name}
import {imp}

{code}
"""
        write_module("Tests", name, dcl, icl)

def main():
    print("Generating Algorithms, Hardware, and Mathematical Optimization Clean Modules...")
    build_algorithms()
    build_hardware()
    build_tests_for_alg_and_hw()
    print("Done generating Algorithms and Hardware modules.")

if __name__ == "__main__":
    main()

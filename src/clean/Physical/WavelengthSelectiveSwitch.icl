implementation module Etalon.Physical.WavelengthSelectiveSwitch

/*
 * WavelengthSelectiveSwitch.icl: LCoS WSS implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.WavelengthSelectiveSwitch
import Etalon.Types.Base
import Etalon.Types.Spectrum

createWssSwitchMatrix :: !Int !Int !Int !Int -> *WssSwitchMatrix
createWssSwitchMatrix mId inPorts outPorts fOrder = {
    matrixId          = mId,
    numInputPorts     = inPorts,
    numOutputPorts    = outPorts,
    filterOrder       = fOrder,
    attenuationMap    = [],
    activeConnections = []
 }

evaluateFilterTransfer :: !SuperGaussianFilter !Real -> Real
evaluateFilterTransfer flt deltaFreqGhz =
    // T(f) = exp(-0.5 * (2 * (f - f0) / B_3dB)^(2n))
    let halfBw = maxReal (flt.bandwidth3DbGhz * 0.5) 0.1
        normFreq = (deltaFreqGhz - flt.centerFreqOffsetGhz) / halfBw
        exponent = 2.0 * toReal flt.order
        arg = 0.5 * (normFreq ^ exponent)
        linearT = exp (~arg)
    in linearT

setSliceAttenuation :: !*WssSwitchMatrix !Int !Real -> *WssSwitchMatrix
setSliceAttenuation wss=:{attenuationMap} sliceIdx attDb =
    let filtered = [(s, a) \ (s, a) <- attenuationMap | s <> sliceIdx]
        newMap = [(sliceIdx, attDb): filtered]
    in { wss & attenuationMap = newMap }

getSliceAttenuation :: !WssSwitchMatrix !Int -> Real
getSliceAttenuation wss sliceIdx =
    case [a \ (s, a) <- wss.attenuationMap | s == sliceIdx] of
        []      -> 0.0
        [val:_] -> val

routeChannelSlot :: !*WssSwitchMatrix !Int !Int !FrequencySlot -> *WssSwitchMatrix
routeChannelSlot wss=:{activeConnections} inP outP slot =
    let newConn = (inP, outP, slot)
    in { wss & activeConnections = [newConn: activeConnections] }

computePortCrosstalkDb :: !WssSwitchMatrix !Int !Int -> Real
computePortCrosstalkDb wss inP outP =
    if (inP == outP) 0.0 (~45.0)

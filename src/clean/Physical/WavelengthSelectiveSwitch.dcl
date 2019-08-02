definition module Etalon.Physical.WavelengthSelectiveSwitch

/*
 * WavelengthSelectiveSwitch.dcl: Liquid Crystal on Silicon (LCoS) WSS model.
 *
 * Models fine-granularity optical switching engine:
 *   - LCoS phase holographic grating transfer functions
 *   - Inter-port optical isolation and adjacent channel crosstalk matrix
 *   - Channel shape profiles: super-Gaussian filter transfer functions
 *   - Dynamic per-slice attenuation for optical power leveling
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum

:: WssPortConfig = {
    portId             :: !Int,
    insertionLossDb    :: !Real,
    isolationDb        :: !Real,
    returnLossDb       :: !Real
}

:: SuperGaussianFilter = {
    order              :: !Int,        // Typical order n = 4..8 for LCoS WSS
    bandwidth3DbGhz    :: !Real,
    insertionLossDb    :: !Real,
    centerFreqOffsetGhz:: !Real
}

:: *WssSwitchMatrix = {
    matrixId           :: !Int,
    numInputPorts      :: !Int,
    numOutputPorts     :: !Int,
    filterOrder        :: !Int,
    attenuationMap     :: ![(!Int, !Real)], // (sliceIndex, attenuationDb)
    activeConnections  :: ![(!Int, !Int, !FrequencySlot)] // (inPort, outPort, slot)
}

createWssSwitchMatrix :: !Int !Int !Int !Int -> *WssSwitchMatrix
evaluateFilterTransfer:: !SuperGaussianFilter !Real -> Real
setSliceAttenuation   :: !*WssSwitchMatrix !Int !Real -> *WssSwitchMatrix
getSliceAttenuation   :: !WssSwitchMatrix !Int -> Real
routeChannelSlot      :: !*WssSwitchMatrix !Int !Int !FrequencySlot -> *WssSwitchMatrix
computePortCrosstalkDb:: !WssSwitchMatrix !Int !Int -> Real

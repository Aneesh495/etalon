
implementation module Etalon.Models.EdfaDualStageModel

import StdEnv
import Etalon.Models.EdfaDualStageModel
import Etalon.Types.Base

computeTotalGainDb :: !DualStageEdfa -> Real
computeTotalGainDb edfa =
    edfa.stage1GainDb + edfa.stage2GainDb - edfa.midStageLossDb

computeCompositeNfDb :: !DualStageEdfa -> Real
computeCompositeNfDb edfa =
    // Friis formula for noise figure: NF_tot = NF1 + (NF2 - 1) / G1_net
    let g1NetLin = 10.0 ^ ((edfa.stage1GainDb - edfa.midStageLossDb) / 10.0)
        nf1Lin = 10.0 ^ (edfa.stage1NoiseFigDb / 10.0)
        nf2Lin = 10.0 ^ (edfa.stage2NoiseFigDb / 10.0)
        totLin = nf1Lin + (nf2Lin - 1.0) / maxReal g1NetLin 0.1
    in 10.0 * (log10 (maxReal totLin 1.0))

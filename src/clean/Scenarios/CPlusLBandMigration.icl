
implementation module Etalon.Scenarios.CPlusLBandMigration

import StdEnv
import Etalon.Scenarios.CPlusLBandMigration
import Etalon.Routing.MultiBandRouting

runCPlusLMigrationSimulation :: Bool
runCPlusLMigrationSimulation =
    let b = selectOptimalBand 0.88 0.10
    in case b of
        BandL -> True
        _     -> False

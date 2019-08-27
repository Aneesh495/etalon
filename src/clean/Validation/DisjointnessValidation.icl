
implementation module Etalon.Validation.DisjointnessValidation

import StdEnv
import Etalon.Validation.DisjointnessValidation
import Etalon.Topology.Path

verifyLinkDisjointness :: !OpticalRoute !OpticalRoute -> Bool
verifyLinkDisjointness r1 r2 =
    let commonLinks = [l \ l <- r1.linkSequence | isMember l r2.linkSequence]
    in isEmpty commonLinks
where
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys

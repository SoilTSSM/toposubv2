#!/bin/bash
#exec > >(tee "run.log") 2>&1
source toposat.ini
exec > >(tee $wd/stdout.log) 2> >(tee $wd/stderr.log >&2)
find $wd/* -delete

./setupDomain.sh
./getERA.sh
./runTopoSUB.sh
./runTopoSCALE.sh
./setupGeotopSim.sh
./runLSM.sh

#if $informSample == TRUE
# ./informSample.sh
# ./runTopoSCALE.sh
# ./setupGeotopSim.sh
# ./runLSM.sh

./getMODIS_SCA.sh TRUE #should be false but does not work yet

# run model
# spatialise results
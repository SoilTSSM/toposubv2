#!/bin/bash
wd=/home/joel/sim/topomap_test/
srcdir=/home/joel/src/TOPOMAP/toposubv2/workdir
runtype=bbox  #bbox points
startDate=2012-12-30
endDate=2012-12-31
samples=10
positions=85.1,27.8,85.8,27.7 #either bbox=(e,s,w,n) single point or list of points
grid=0.25 #era grid resoltion in degrees
#if runtype=points
#lon 
#lat


cd $srcdir
Rscript getDEM.R $wd $runtype $positions $grid

Rscript makeSurface.R $wd
Rscript getERA.R $wd $runtype $startDate $endDate $grid
Rscript toposcale_pre.R $wd $startDate $endDate

Rscript prepareSims.R $wd


Rscript toposub.R $wd $samples

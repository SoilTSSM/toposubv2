#!/bin/bash

#====================================================================
# INPUT PARAMETERS
#====================================================================
wd=/home/joel/sim/topomap_test/
srcdir=/home/joel/src/TOPOMAP/toposubv2/workdir
demDir=/home/joel/data/DEM/srtm
MODISdir=/home/joel/data/MODIS_ARC/ #set in MODISoptions(), persistent thru package upgrades
runtype=bbox  #bbox or points or basin
startDate=2012-12-30
endDate=2012-12-31
samples=10
positions=85.1,27.8,85.8,27.7 #either bbox=(e,s,w,n) 4 vals or list of points (file with N-colums and rows) need to identify which based on data structure
grid=0.25 #era grid resolution in degrees
svfCompute=FALSE

pfactor=0.25 				#liston precipitation parameter
tz=-5				#timezone, negative = west (used in package:insol)

#MODES
# - point sim (toposcale + 1D model)
# - large area spatial sim (toposcale + toposub + 1D model)
# - basin sim (full 2d eg run off etc) (toposcale + 2D model)



#====================================================================
# SCRIPT
#====================================================================
cd $srcdir

# Fetch DEM(s) for bbox
Rscript getDEM.R $wd $demDir $positions 

# Clip to nearest ERA-extent
Rscript clipToEra.R $wd $grid

# Generate topo layers
Rscript computeTopo.R $wd $svfCompute

# Make surface from MODIS (fetch) and DEM
Rscript makeSurface.R $wd $MODISdir

# Fetch ERA-data
Rscript getERA.R $wd $runtype $startDate $endDate $grid

# Preprocess ERA-data
Rscript toposcale_pre.R $wd $startDate $endDate

# Prepare sim predicters and directories per ERA-grid
Rscript prepareSims.R $wd

# Returns number of cells in ERA-Grid extent"
ncells=$(Rscript getRasterDims.R $wd eraExtent.tif) 
echo "ERA-Grid cells= " $ncells 

# Run toposub on each ERA grid
for Ngrid in $(seq 1 $ncells); do
	gridpath=$wd'grid'$Ngrid
	Rscript toposub.R $gridpath $samples $Ngrid
done

# compute elevations of each box and write out
Rscript eraBoxEle.R $wd 'predictors/ele.tif' 'eraExtent.tif'

# Run toposcale
for Ngrid in $(seq 1 $ncells); do
	
	#get box ele using Ngrid pass as arg
	gridpath=$wd'grid'$Ngrid
	Rscript boxMetadata.R $gridpath $Ngrid
	Rscript tscale_SW.R $gridpath $Ngrid FALSE $tz #TRUE requires svf as does more computes terrain/sky effects
	Rscript tscale_Rhum.R $gridpath $Ngrid

	
	parallel   Rscript ::: tscale_SW.R tscale_Rhum.R tscale_windU.R tscale_Tair.R tscale_windV.R tscale_P.R

done



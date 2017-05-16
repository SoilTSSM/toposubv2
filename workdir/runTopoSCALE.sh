#!/bin/bash
source toposat.ini

echo "precip pfactor used:" $pfactor

# Returns number of cells in ERA-Grid extent"
ncells=$(Rscript getRasterDims.R $wd spatial/eraExtent.tif) 
echo "ERA-Grid cells= " $ncells 

# compute elevations of each box and write out
Rscript eraBoxEle.R $wd 'predictors/ele.tif' 'spatial/eraExtent.tif'

echo '========================================================='
echo 'RUN TOPOSCALE'
echo '========================================================='
# Run toposcale
for Ngrid in $(seq 1 $ncells); do
	echo "Running TopoSCALE GRID" $Ngrid 
	#get box ele using Ngrid pass as arg
	gridpath=$wd'/grid'$Ngrid
	Rscript boxMetadata.R $gridpath $Ngrid
	Rscript tscale_rhum.R $gridpath $Ngrid
	Rscript tscale_tair.R $gridpath $Ngrid
	Rscript tscale_windu.R $gridpath $Ngrid
	Rscript tscale_windv.R $gridpath $Ngrid
	Rscript tscale_sw.R $gridpath $Ngrid FALSE $tz #TRUE requires svf as does more computes terrain/sky effects
	Rscript tscale_lw.R $gridpath $Ngrid $svfCompute
	Rscript tscale_p.R $gridpath $Ngrid $pfactor
done



#!/bin/bash
# creates a listpoints for each ERA-grid
echo $(basename $BASH_SOURCE)  'running........'
source $wd/toposat.ini



# Returns number of cells in ERA-Grid extent"
ncells=$(Rscript getRasterDims.R $wd spatial/eraExtent.tif) 
echo "Setting up simulation directories for $ncells  ERA-Grids" 

# set up sim directoroes #and write metfiles
for Ngrid in $(seq 1 $ncells); do
	echo 'creating listpoints for grid' $Ngrid
	gridpath=$wd'/grid'$Ngrid
	if [ ! -d "$gridpath" ]; then
   	echo "Grid "$Ngrid" has been removed because it contained no points. Now processing "$Ngrid+1
   	continue
 	fi
	Rscript makeListpoints.R $gridpath $pointsFile
done


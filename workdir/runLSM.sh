
#!/bin/bash
source toposat.ini

#========================================================================
#               make batch file
#========================================================================
# Returns number of cells in ERA-Grid extent"
ncells=$(Rscript getRasterDims.R $wd spatial/eraExtent.tif) 
echo "Setting up simulation directories for $ncells  ERA-Grids" 

# set up sim directoroes #and write metfiles
for Ngrid in $(seq 1 $ncells); do
	echo "Simulations grid" $Ngrid "running"
	gridpath=$wd'/grid'$Ngrid
	cd $gridpath
	batchfile=batch.txt
	sim_entries=$gridpath/S*
	echo 'cd ' $lsmPath > $batchfile
	echo 'parallel' ./$lsmExe ' ::: ' $sim_entries >> $batchfile
	chmod u+x $batchfile
	./$batchfile
done